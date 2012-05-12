require 'net/http'

def get_from_server address
  uri = URI(address)

  Net::HTTP.start(uri.host, uri.port) do |http|
    request = Net::HTTP::Get.new uri.request_uri
    response = http.request request # Net::HTTPResponse object
    puts response.body
  end

end

def send_message(msg,username,channel)
  uri = URI("http://127.0.0.1:3000/message_client/")
  req = Net::HTTP::Post.new(uri.path)
  req.set_form_data({"authenticity_token"=>"nF6xmLqUBO6TieDF7yNeCxV18smil6hV3omA/s3ljoM=" ,
  'message[content]'=> msg ,
  'message[from]' => username ,
  'message[channel_id]' => channel,
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
  uri = URI("http://127.0.0.1:3000/login_from_desktop.json")
   req = Net::HTTP::Post.new(uri.path)
   req.set_form_data({"authenticity_token"=>"nF6xmLqUBO6TieDF7yNeCxV18smil6hV3omA/s3ljoM=" ,
   'user[username]'=>"#{user[:username]}" , "user[provider]" => "desktop", "commit"=>"Enviar" })
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

#user = {:username => "Carlos"}
#login user
#send_message "Hola desde el cliente de parte de #{user[:username]} 3D3D recargado" , user[:username] , 117

get_from_server "http://127.0.0.1:3000/chat.json"





