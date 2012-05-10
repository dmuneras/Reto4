class MessagesController < ApplicationController
  before_filter :current_user? , :except => [:create_client, :chat, :index]
  def index 
      @messages = Message.message_by_channel(current_channel,current_user) 
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
            format.js {
              if !(@message.to.nil?)
                @channel_user = "#{current_channel_route}/#{@message.to_user.id}"
                PrivatePub.publish_to(@channel_user, message: @message)
              else
                PrivatePub.publish_to(current_channel_route, message: @message)
              end
            }
          else
            @error_msg = @message.errors.full_messages[0]
            format.js {render 'new'}
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
    #channel = current_channel_client(params[:channel_id])
    if client
      @message = Message.create! params[:message]  
      @message.from = client.id
      @message.save
      format.js {PrivatePub.publish_to(current_channel_route, message: @message)}
      render 'create'
    end
  end
  
  def destroy 
    if current_user
      Message.destroy params[:id]
      PrivatePub.publish_to(current_channel_route, "location.reload();$('#channel_name').reset();")
      redirect_to root_url, :notice => t(:successfully_d)
    else
      redirect_to root_url
    end
  end
  
  def update_chat  
    unless params[:channel_id].blank? 
      session[:channel_id] = params[:channel_id] unless params[:channel_id].blank? 
      @user_msg = "#{t(:new_channel_selected)} : #{current_channel.name}"
    else
      redirect_to root_url
    end
  end
  
  def chat
    @messages = Message.message_by_channel(current_channel, current_user) 
    logger.info "====> Valid MESSAGE: #{@message}"
    @users = User.all
    respond_to do |format|
      format.html{
        render :layout => false
      }
      format.json{
        chat_data = Hash.new
        chat_data = {:msgs => @messages, :users => @users, :channel => current_channel_route}
        render json: chat_data
      }
    end
  end
end


