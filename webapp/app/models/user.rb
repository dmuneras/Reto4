class User < ActiveRecord::Base
  
  
  belongs_to :channel
  has_many :roles_userss
  has_many :roles, :through => :roles_userss 
  
  has_many :created_msgs ,  :class_name => 'Message', :foreign_key => 'from'
  has_many :received_msgs , :class_name => 'Message', :foreign_key => 'to'
  
   validates :username, :uniqueness => {:message => I18n.t(:name_unique_user_error)}
  
  attr_accessible  :password, :password_confirmation,:username , :roles_mask , :provider, :roles
  
  ROLES = %w[admin user]
   
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
  
  def self.users_by_channel channel
    return User.all.select{|user| user.channel == channel}
  end
  
  def roles=(roles)
     self.roles_mask= (roles & ROLES).map { |r| 2**ROLES.index(r) }.sum
   end

   def roles
     ROLES.reject { |r| ((roles_mask || 0) & 2**ROLES.index(r)).zero? }
   end

   def role?(role)
     roles.include? role.to_s
   end
   
end
