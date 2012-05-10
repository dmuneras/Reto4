class Channel < ActiveRecord::Base
 validates :name, :presence => {:message => 'name cannot be blank, channel not saved'}
 validates :name, :uniqueness => {:message => 'name have to be unique'}
end
