require 'net/http'
require 'services'
require 'userMsgs'
require 'yaml'
require "highline/import"

class User 
  
  include Services
  include UserMsgs
  
  def initialize(username)
    config = YAML.load_file(File.expand_path("./config/config.yml"))
    @provider = config["server"] 
    puts "Conectando a #{@provider}"
    @username, @online = username[0], false
    main_loop
  end
  
  private
  
  def main_loop
    while !(@online)
      pwd = ask("Ingrese clave: ") {|q| q.echo = "x"} 
      @online = login(@username, pwd , "#{@provider}/local_login.json")
    end
    puts "Bienvenido #{@username}"
    puts "Estos son los canales disponibles"
    @channels = get_from_server "#{@provider}/channels.json"
    for channel in @channels
       puts channel["name"]
    end
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
     unless @current_channel.nil?
        msg = msg.split
        msg = msg - [msg[0]]
        channel = @channels.select{|channel| channel["name"].eql? @current_channel}
        send_message(msg.join(" "),@username,channel[0]["id"],nil, "#{@provider}/message_client/")
     else
       puts "No a seleccionado canal"
     end
   end

end