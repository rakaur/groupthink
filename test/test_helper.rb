ENV["RAILS_ENV"] ||= "test"

require "simplecov"
require "simplecov_json_formatter"
SimpleCov.formatter = SimpleCov::Formatter::JSONFormatter

SimpleCov.start do
  add_filter "/test/"
  add_filter "app/controllers/turbo_devise_controller.rb"
  add_filter "config/initializers/devise.rb"
end

require_relative "../config/environment"
require "rails/test_help"

class ActiveSupport::TestCase
  include Devise::Test::IntegrationHelpers

  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  setup { sign_in users(:admin) }

  # Add more helper methods to be used by all tests here...
end
