require 'net/http'
require 'twitter'
require 'hpricot'
require 'json'
require 'digest/md5'

def get_from_server address
  uri = URI(address)

  Net::HTTP.start(uri.host, uri.port) do |http|
    request = Net::HTTP::Get.new uri.request_uri
    response = http.request request # Net::HTTPResponse object
    response = JSON.parse response.body
    for channel in response 
      puts channel["name"]
    end
    
  end

end

def send_message(msg,username,channel,to)

  uri = URI("http://127.0.0.1:3000/message_client/")
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
     puts res.body
  else
    res.value
  end
end

def login(user)
  uri = URI("http://127.0.0.1:3000/local_login.json")
   req = Net::HTTP::Post.new(uri.path)
   pwd = Digest::MD5.hexdigest(user[:pwd])
   req.set_form_data({"authenticity_token"=>"nF6xmLqUBO6TieDF7yNeCxV18smil6hV3omA/s3ljoM=" ,
   'user[username]'=> user[:username] ,
   'user[password]' => pwd ,
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


def register user
  uri = URI("http://127.0.0.1:3000/register.json")
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
#user = {:username => "carlos", :pwd => "carlos"}
login user
#send_message "No se muevan, ya regresamos y me canse" , "carlos" ,  1 , nil

