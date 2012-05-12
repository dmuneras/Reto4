class Channel < ActiveRecord::Base
 validates :name, :presence => {:message => I18n.t(:name_channel_error)}
 validates :name, :uniqueness => {:message => I18n.t(:name_unique_channel_error)}
end
