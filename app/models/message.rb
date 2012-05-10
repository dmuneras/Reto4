class Message < ActiveRecord::Base
  belongs_to :channel
  belongs_to :to_user , :class_name => 'User', :foreign_key => 'to'
  belongs_to :from_user , :class_name => 'User', :foreign_key => 'from'
  validates :content, :presence => {:message => 'Content cannot be blank, content not saved'}
  
  def self.message_by_channel(channel,user)
      channel_msgs = Message.all.select{|msg| msg.channel == channel}
      channel_msgs.delete_if {|msg| !(msg.to_user.nil?) && msg.to_user != user}
      return channel_msgs
  end
  
end
