# test/controllers/api/v1/authentication_controller_test.rb
require 'test_helper'

class Api::V1::AuthenticationControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one) # Assuming you have a user fixture
  end

  test 'should log in with valid credentials' do
    post api_v1_login_path, params: { email: @user.email, password: 'password' }
    assert_response :success
    assert_not_nil JSON.parse(response.body)['token']
  end

  test 'should not log in with invalid credentials' do
    post api_v1_login_path, params: { email: @user.email, password: 'wrongpassword' }
    assert_response :unauthorized
  end

  test 'should not access protected route without token' do
    get api_v1_ip_geolocations_path
    assert_response :unauthorized
  end
end
