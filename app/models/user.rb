class User < ActiveRecord::Base
  
  attr_accessor :subscriptions
  
  has_many :created_msgs ,  :class_name => 'Message', :foreign_key => 'from'
  has_many :received_msgs , :class_name => 'Message', :foreign_key => 'to'
  
  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.username = auth["info"]["name"]
    end
  end
  
  def my_private_msg? msg
    return true if self.received_msgs.include? msg
  end
end
