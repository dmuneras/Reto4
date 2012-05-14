root = File.dirname(__FILE__)
$:.unshift root + "/models"

require "user"

unless ARGV.length == 1
  STDERR.puts "Usage: #{$0} <nickname>"
  exit 1
end

$nickname = ARGV
user = User.new($nickname)


