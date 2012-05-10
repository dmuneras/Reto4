class User < ActiveRecord::Base
  
  has_many :created_msgs ,  :class_name => 'Message', :foreign_key => 'from'
  has_many :received_msgs , :class_name => 'Message', :foreign_key => 'to'
  
  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.username = auth["info"]["name"]
    end
  end
  
  def self.to_select
    users = []
    for user in User.all
      users << {user.username => user.id}
    end
    return users
  end
  
end
