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
            flash[:error] = "Datos incorrectos"
            redirect_to local_login_form_path
          end
        else
          redirect_to root_url
        end

      }
      format.json{
        user = User.find_by_username params["user"]["username"]
        if user
          response = Hash.new
          if user.password.eql? params["user"]["password"]
            response = {:res => true, :user_id => user.id}
          else
            response = {:res => false}
          end
          render json: response
        else
          render json: "Invalid username" 
        end
      }
    end
  end

  def destroy
    respond_to do |format|
    format.html{current_user.channel_id = nil
      current_user.save
      session[:user_id] = nil
      session[:channel_id] = nil
      redirect_to root_url, :notice => t(:signed_out)
    }
    format.json{
      user = User.find_by_username params["user"]["username"]
      if user
        PrivatePub.publish_to("/messages/new/#{user.channel.name}",
           "$(\"#message_to option:regex(value,#{user.id})\").remove();
           $('#message_to').trigger('liszt:updated');")
        user.channel_id = nil
        user.save
      end
      render json: true
    }
    end
  end
  
  def new
  end
  
end
