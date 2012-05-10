# Run with: rackup private_pub.ru -s thin -E production
require "bundler/setup"
require "yaml"
require "faye"
require "private_pub"

PrivatePub.load_config(File.expand_path("../config/private_pub_redis.yml", __FILE__), ENV["RAILS_ENV"] || "development")
run PrivatePub.faye_app
