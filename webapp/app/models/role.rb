class Role < ActiveRecord::Base
  has_many :roles_userss
  has_many :users, :through => :roles_userss
end
