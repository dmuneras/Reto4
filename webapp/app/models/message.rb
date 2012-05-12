class Message < ActiveRecord::Base
  belongs_to :channel
  belongs_to :to_user , :class_name => 'User', :foreign_key => 'to'
  belongs_to :from_user , :class_name => 'User', :foreign_key => 'from'
  validates :content, :presence => {:message => I18n.t(:content_presence_msg) }
  
  def self.messages_by_channel(channel,user)
      return Message.all.select{|msg| msg.channel == channel}.delete_if {|msg| !(msg.to_user.nil?) && msg.to_user != user}
  end
  
end
