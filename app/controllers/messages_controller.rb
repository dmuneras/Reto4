class MessagesController < ApplicationController
  before_filter :current_user? , :except => [:create_client, :chat, :index]
  def index 
      @messages = Message.message_by_channel current_channel 
      @users = User.all
      @channels = Channel.all   
  end

  def create
    if current_user
      respond_to do |format| 
        begin
          @message = Message.new params[:message]
          @message.from , @message.channel_id  = current_user.id , current_channel.id 
          if @message.save
            format.js {PrivatePub.publish_to("/messages/new", message: @message)}
          else
            @error_msg = @message.errors.full_messages[0]
            format.js {render 'new'}
          end
        rescue Exception => e
          format.js {render 'new'}
        end
      end
    else
      redirect_to root_url
    end
  end

  def create_client
    client = current_user_client(params[:client_username])
    #channel = current_channel_client(params[:channel_id])
    if client
      @message = Message.create! params[:message]  
      @message.from = client.id
      @message.save
      PrivatePub.publish_to("/messages/new", message: @message)
      render 'create'
    end
  end
  
  def destroy 
    if current_user
      Message.destroy params[:id]
      PrivatePub.publish_to("/messages/new", "location.reload();$('#channel_name').reset()")
      redirect_to root_url, :notice => t(:successfully_d)
    else
      redirect_to root_url
    end
  end
  
  def update_chat   
    session[:channel_id] = params[:channel_id] unless params[:channel_id].blank? 
    @user_msg = "#{t(:new_channel_selected)} : #{current_channel.name}"
  end
  
  def chat
    @messages = Message.message_by_channel current_channel 
    @users = User.all
    respond_to do |format|
      format.html{
        if current_channel
          @title = current_channel.name
        end
        render :layout => false
      }
      format.json{
        chat_data = Hash.new
        chat_data = {:msgs => @messages, :users => @users}
        render json: chat_data
      }
    end
  end
end


