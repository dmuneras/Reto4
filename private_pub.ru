# Run with: rackup private_pub.ru -s thin -E production
require "bundler/setup"
require "yaml"
require "faye"
require "private_pub"

PrivatePub.load_config(File.expand_path("../config/private_pub.yml", __FILE__), ENV["RAILS_ENV"] || "development")
faye_server = Faye::RackAdapter.new(
			:mount => '/faye', 
			:timeout => 25,
			:engine => {
				:type => 'redis',
				:host => 'panga.redistogo.com',
				:port => '9466',
				:password => 'c82bd6eb849dc7cc887ee03d0ca12414',
				:database => 1
			})
			
run faye_server
