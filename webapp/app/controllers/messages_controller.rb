class MessagesController < ApplicationController

  before_filter :current_user? , :except => [:create_client, :chat, :index]
  def index 
    respond_to do |format| 
      format.html{
        @messages = Message.messages_by_channel(current_channel,current_user) 
        @users = User.users_by_channel current_channel
        @channels = Channel.all  
      }
    end
  end

  def create
    if current_user
      respond_to do |format| 
        begin
          @message = Message.new params[:message]
          @message.from , @message.channel_id  = current_user.id , current_channel.id 
          if @message.save
            format.js {
              if !(@message.to.nil?)
                @channel_user = "/messages/#{@message.to_user.id}"
              end
            }
          else
            @error_msg = @message.errors.full_messages[0]
            format.js {render 'create_error'}
          end
        rescue Exception => e
          @expection = e.message
          format.js {render 'new'}
        end
      end
    else
      redirect_to root_url
    end
  end

  def create_client
    client = current_user_client(params[:client_username])
    if client
      @message = Message.create! params[:message]  
      @message.from = client.id
      @message.save
      respond_to do |format|
        
      format.js {
        render 'create_from_client'
      }
      end
    end
  end
  
  def destroy 
    respond_to do |format|
      format.js{
        if current_user
          Message.destroy params[:id]
          PrivatePub.publish_to(current_channel_route, "$('li#message-#{params[:id]}').remove();")
          render :nothing => true
        else
          redirect_to root_url
        end
      }
    end
  end

  def update_chat  
    unless params[:channel_id].blank?
        session[:channel_id] = params[:channel_id] 
        previous_channel = current_user.channel
        @user_msg = "#{t(:new_channel_selected)} : #{current_channel.name}"
        current_user.channel_id = params[:channel_id]
        current_user.save
        logger.info "PREVIOUS CHANNEL : #{previous_channel.name if previous_channel}," <<
         "CURRENT_CHANNEL : #{current_channel.name if current_channel}"
        if previous_channel
          if previous_channel != current_channel
            logger.info "\n\n\n-------------> REMOVI #{current_user.username} de /messages/new/#{previous_channel.name}\n\n\n"
            PrivatePub.publish_to("/messages/new/#{previous_channel.name}",remove_user_from_list(current_user.id)) 
          end
        end
        logger.info "\n\n\n----------------> AGREGE #{current_user.username} de #{current_channel_route}\n\n\n"
        PrivatePub.publish_to(current_channel_route,append_user_to_list(current_user.id , current_user.username))  
            
    else
      redirect_to root_url
    end
  end
  
  def chat
    respond_to do |format|  
      format.html{
        @messages = Message.messages_by_channel(current_channel, current_user) 
        @users = User.users_by_channel current_channel
        render :layout => false
      }
      format.json{
        chat_data = Hash.new
        channel = Channel.find_by_name(params["channel"])
        user = User.find_by_username(params["username"])
        @messages = Message.messages_by_channel(channel, user) 
        @users = User.users_by_channel channel
        chat_data = {:msgs => @messages, :users => @users}
        render json: chat_data
      }
    end
  end
  
end


