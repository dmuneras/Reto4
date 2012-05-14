require 'net/http'
require 'hpricot'
require 'json'
require 'digest/md5'

module Services

  def get_from_server(uri)
     uri = URI(uri)
     Net::HTTP.start(uri.host, uri.port) do |http|
       request = Net::HTTP::Get.new uri.request_uri
       response = http.request request # Net::HTTPResponse object
       return  JSON.parse response.body
     end
  end

  def send_message(msg,username,channel,to,uri)
    uri = URI(uri)
    req = Net::HTTP::Post.new(uri.path)
    req.set_form_data({"authenticity_token"=>"nF6xmLqUBO6TieDF7yNeCxV18smil6hV3omA/s3ljoM=" ,
      'message[content]'=> msg ,
      'message[from]' => username ,
      'message[channel_id]' => channel,
      'message[to]' => to,
      'client_username' => username,
      'agent' => 'desktop',
      'commit'=>'Enviar' })

      res = Net::HTTP.start(uri.hostname, uri.port) do |http|
        http.request(req)
      end
      case res
        when Net::HTTPSuccess, Net::HTTPRedirection
          puts "Mensaje enviado"
        else
          res.value
      end
  end

  def login(username, pwd , uri)
    uri = URI(uri)
    req = Net::HTTP::Post.new(uri.path)
    pwd = Digest::MD5.hexdigest(pwd)
    req.set_form_data({"authenticity_token"=>"nF6xmLqUBO6TieDF7yNeCxV18smil6hV3omA/s3ljoM=" ,
      'user[username]'=> username,
      'user[password]' => pwd ,
      "commit"=>"Enviar" })
      res = Net::HTTP.start(uri.hostname, uri.port) do |http|
        http.request(req)
      end
      case res
        when Net::HTTPSuccess, Net::HTTPRedirection
          response = JSON.parse res.body 
          return response["res"]
        else
          return res.value
      end  
  end


  def register(user,uri)
    #uri = URI("http://127.0.0.1:3000/register.json")
    req = Net::HTTP::Post.new(uri.path)
    pwd = Digest::MD5.hexdigest(user[:pwd])
    req.set_form_data({"authenticity_token"=>"nF6xmLqUBO6TieDF7yNeCxV18smil6hV3omA/s3ljoM=" ,
      "user[username]"=> user[:username] ,
      "user[provider]" => "local",
      "user[password]" => pwd ,
      "commit"=>"Enviar" })
      res = Net::HTTP.start(uri.hostname, uri.port) do |http|
        http.request(req)
      end
      case res
        when Net::HTTPSuccess, Net::HTTPRedirection
          puts res.body
        else
          puts res.value
      end
  end

end

