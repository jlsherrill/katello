require  "#{File.dirname(__FILE__)}/../../../test/katello_test_helper.rb"

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

class ActionController::TestCase
  def setup_engine_routes
    @routes = Fort::Engine.routes
  end
end
