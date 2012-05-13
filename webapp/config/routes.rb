Chatter::Application.routes.draw do
  
  resources :channels 
  resources :messages
  resources :users
  
  match "/auth/:provider/callback" => "sessions#create"
  match "/register_client" => "users#register_client"
  match "/login" => "sessions#create"
  match "/signout" => "sessions#destroy"
  match "/local_login_form" => "sessions#new"
  match "/local_login" => "sessions#local_login"
  match "/update_chat" => "messages#update_chat"
  match "/message_client" => "messages#create_client"
  match '/chat' => "messages#chat"
    
  root to: 'messages#index'
end
