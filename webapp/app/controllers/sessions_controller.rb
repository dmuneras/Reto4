class SessionsController < ApplicationController
  
  def create
    auth = request.env["omniauth.auth"]
    user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) || User.create_with_omniauth(auth)
    respond_to do |format|
      format.html {
        session[:user_id] = user.id
        redirect_to root_url, :notice => t(:signed_in)
      }
      format.json{
        if user
          render json: user
        else
          render json: false
        end
      }
    end
  end

  def local_login
    respond_to do |format|
      format.html{
        user = User.find_by_username params["user"]["username"]
        if user
          if user.password.eql?  Digest::MD5.hexdigest(params["user"]["password"])
            session[:user_id] = user.id
            redirect_to root_url, :notice => t(:signed_in)
          else
            render json: false
          end
        else
          redirect_to root_url
        end

      }
      format.json{
        user = User.find_by_username params["user"]["username"]
        if user
          if user.password.eql? params["user"]["password"]
            render json: true
          else
            render json: false
          end
        else
          render json: "Invalid username" 
        end
      }
    end
  end

  def destroy
    session[:user_id] = nil
    session[:channel_id] = nil
    redirect_to root_url, :notice => t(:signed_out)
  end
  
  def new
  end
end
