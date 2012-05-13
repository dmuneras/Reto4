class ChannelsController < ApplicationController
   before_filter :current_user? , :except => [:index]
  # GET /channels
  # GET /channels.json
  def index
    @channels = Channel.all

    respond_to do |format|
      format.html{ current_user?} # index.html.erb
      format.json { render json: @channels }
      format.xml {render xml: @channels}
    end
  end

  # GET /channels/1
  # GET /channels/1.json
  def show
    @channel = Channel.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @channel }
    end
  end

  # GET /channels/new
  # GET /channels/new.json
  def new
    @channel = Channel.new
    respond_to do |format|
      format.json { render json: @channel }
    end
  end

  # GET /channels/1/edit
  def edit
    @channel = Channel.find(params[:id])
  end

  # POST /channels
  # POST /channels.json
  def create
    @channel = Channel.new(params[:channel])
    respond_to do |format|
      if @channel.save
        format.js {@user_msg = "#{t(:new_channel_created)} : #{@channel.name}"}
        format.json { render json: @channel, status: :created, location: @channel }
      else
        @error_msg = @channel.errors.full_messages[0]
        format.js { render action: "errors" }
        format.json { render json: @channel.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /channels/1
  # PUT /channels/1.json
  def update
    @channel = Channel.find(params[:id])
    respond_to do |format|
      if @channel.update_attributes(params[:channel])
        format.html { redirect_to @channel, notice: 'Channel was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @channel.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /channels/1
  # DELETE /channels/1.json
  def destroy
    @channel = Channel.find(params[:id])
    @channel.destroy
    respond_to do |format|
      format.html { redirect_to channels_url }
      format.json { head :ok }
    end
  end
end


