require 'net/http'
require 'services'
require 'userMsgs'
require 'yaml'
require "highline/import"
require 'thread'

class User 
  
  include Services
  include UserMsgs
  
  def initialize(username)
    config = YAML.load_file(File.expand_path("./config/config.yml"))
    @provider = config["server"] 
    @msgs_queue = Queue.new
    @last_ask = DateTime.now
    puts "Conectando a #{@provider}"
    @username, @online = username[0], false
    main_loop
  end
  
  private
  
  def main_loop
    while !(@online)
      pwd = ask("Ingrese clave: ") {|q| q.echo = "x"} 
      @online = login(@username, pwd , "#{@provider}/local_login.json")
      puts "Intente de nuevo ... "unless @online
    end
    puts "Bienvenido #{@username}"
    puts "Estos son los canales disponibles"
    @channels = get_from_server "#{@provider}/channels.json"
    for channel in @channels
       puts "=>" << channel["name"]
    end
    update_from_server
    while @online
      read_from_console
    end
  end
  
  
  def read_from_console
     cmd = STDIN.gets
     cmd = cmd.chop
     if cmd.eql?"quit"
       @online =  false
     elsif cmd.eql?"\n"
       puts "No ingreso nada"
     elsif cmd.eql?"help"
       puts user_help
     elsif cmd =~ /canal:/
       set_current_channel cmd
     elsif cmd =~ /enviar:/
       send_msg cmd
     elsif cmd.eql? "usuarios"
       puts channels_user
     else
       puts "Comando erroneo" 
     end
   end
   
   def set_current_channel msg
     @current_channel =  msg.split[1]
     @channel_info = get_from_server "#{@provider}/chat.json?username=#{@username}&channel=#{@current_channel}"
     puts "Ahora el canal actual es: #{@current_channel}"
     puts "Usuarios disponibles:"
     for user in @channel_info["users"]
       puts "=>" << user["username"]
     end
   end
   
   def send_msg msg
     if @current_channel
        msg = msg.split
        msg = msg - [msg[0]]
        channel = @channels.select{|channel| channel["name"].eql? @current_channel}
        send_message(msg.join(" "),@username,channel[0]["id"],nil, "#{@provider}/message_client/")
     else
       puts "No a seleccionado canal"
     end
   end

   def channels_user
    if @current_channel
      result = ""
      for user in @channel_info["users"]
        result << "=> #{user["username"]}\n"
      end
      return result
    else
     return "No ha seleccionado canal"
    end
   end
   def update_from_server
     @ask = Thread.new do
       while @online 
         if @current_channel
           @channel_info = get_from_server "#{@provider}/chat.json?username=#{@username}&channel=#{@current_channel}"
           for msg in @channel_info["msgs"]
             @msgs_queue << msg if ((DateTime.strptime(msg['created_at'])) <=> @last_ask) == 1
           end
           if @msgs_queue.size > 0
             @msgs_queue.size.times do
                msg = @msgs_queue.pop
                user = @channel_info["users"].select{|user| user["id"] == msg["from"]}[0]
                puts "#{user["username"]} : #{msg['content']} ,   enviado => #{msg['created_at']}"
              end
           end
           @last_ask = DateTime.now
           sleep(1)
         end
       end
     end
  end
end