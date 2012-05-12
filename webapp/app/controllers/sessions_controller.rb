class SessionsController < ApplicationController
  
  def create
    auth = request.env["omniauth.auth"]
    user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) || User.create_with_omniauth(auth)
    session[:user_id] = user.id
    redirect_to root_url, :notice => t(:signed_in)
  end

  def login_from_desktop
    respond_to do |format|
      format.json{
        user = User.find_by_username params[:user][:username]
        if user.nil?
          user = User.create!(params[:user])
        end
        render json: user
      }
    end
  end

  def destroy
    session[:user_id] = nil
    session[:channel_id] = nil
    redirect_to root_url, :notice => t(:signed_out)
  end
end
