Chatter::Application.routes.draw do
 
  resources :channels 
  
  resources :messages 
  match "/auth/:provider/callback" => "sessions#create"
  match "/signout" => "sessions#destroy", :as => :signout
  match "/login_from_desktop" => "sessions#login_from_desktop"
  match "/update_chat" => "messages#update_chat"
  match "/message_client" => "messages#create_client"
  match '/chat' => "messages#chat"
  root to: 'messages#index'
end
