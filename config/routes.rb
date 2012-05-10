Chatter::Application.routes.draw do
 
  resources :channels
  resources :messages 
  match "/auth/:provider/callback" => "sessions#create"
  match "/signout" => "sessions#destroy", :as => :signout
  match "/login_from_desktop" => "sessions#login_from_desktop", :as => :login_from_desktop
  match "/update_chat" => "messages#update_chat", :as => :update_chat
  match "/update_channels" => "channels#update_channels" , :as => :update_channels
  match "/message_client" => "messages#create_client" , :as => :create_client
  match '/chat' => "messages#chat", :as => :chat
  root to: 'messages#index'
end
