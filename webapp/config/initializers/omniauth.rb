Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, 'd6hz6YHiGG5aTwxeW4aiw', 'OP600DqUj7mnQxENCgF0s8cE6RiYepwWViZxwn5CRvk'
  provider :facebook, '	245210025586626',  'b54c86e6904f0ed6fe8815fe39f3ea66', :scope => 'email,offline_access,read_stream', :display => 'popup'
end

