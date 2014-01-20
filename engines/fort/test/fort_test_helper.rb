# Configure Rails Environment
ENV["RAILS_ENV"] = "test"


#require "#{File.dirname(__FILE__)}/../../../lib/katello"

require 'factory_girl_rails'
require "webmock/minitest"
require "mocha/setup"



#require "rails/test_help"
#require  "#{Katello::Engine.root}/test/katello_test_helper.rb"
require  "#{File.dirname(__FILE__)}/../../../test/katello_test_helper.rb"

class Fort::TestCase < ActionController::TestCase
  def setup_engine_routes
    @routes = Fort::Engine.routes
  end
end





Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }
