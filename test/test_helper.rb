# test/test_helper.rb
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'webmock/minitest'

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

class ActionDispatch::IntegrationTest
  # Helper method to log in as a user
  def login_as(user, password: 'password')
    post api_v1_login_path, params: { email: user.email, password: password }
    @token = JSON.parse(response.body)['token']
  end

  # Helper method to set the Authorization header
  def auth_headers
    { 'Authorization' => "Bearer #{@token}" }
  end
end
