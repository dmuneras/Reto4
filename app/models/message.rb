class Message < ActiveRecord::Base
  belongs_to :channel
  validates :content, :presence => {:message => 'Content cannot be blank, content not saved'}
  
  def self.message_by_channel channel
    return Message.all.select{|msg| msg.channel == channel} if channel
  end
end
