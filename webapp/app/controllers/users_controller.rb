class UsersController < ApplicationController

  def new
    @user = User.new
     respond_to do |format|
       format.html  # new.html.erb
       format.json  { render :json => @user }
     end
  end

  def create
    @user = User.new(params[:user])
    @user.password = Digest::MD5.hexdigest @user.password
    @user.provider = 'local'
    respond_to do |format|
      if @user.save
        format.html  { redirect_to(root_url,
                      :notice => t(:user_was_successfully_created)) }
        format.json  { render :json => @user,
                      :status => :created, :location => @user }
      else
        format.html  { render :action => "new" }
        format.json  { render :json => @user.errors,
                      :status => :unprocessable_entity }
      end
    end
  end

  def register_client
    respond_to do |format|
      format.json{
        user = User.new(params["user"])
        if user.save
          render json: true
        else
          render json: user.errors.full_messages
        end 
      }
    end

  end

end 