require "test_helper"

class IpGeolocationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @current_user = users(:one) # Assuming you have a user fixture
    login_as(@current_user)
    @ip_geolocation = ip_geolocations(:one)
    @ip = '2.1.2.2'
    @api_key = 'IPSTACK_API_KEY'  # Replace with your actual IPStack API key

    # Stubbing the request to the ipgeolocation.io API
    stub_request(:get, "https://api.ipgeolocation.io/ipgeo")
      .with(query: { apiKey: @api_key, ip: @ip })
      .to_return(status: 200, body: {
        ip: '2.1.2.2',
        continent_name: 'Europe',
        country_name: 'France',
        city: 'Paris',
        latitude: 48.8566,
        longitude: 2.3522
      }.to_json, headers: { 'Content-Type' => 'application/json' })

  end

  def login_as(user)
    post api_v1_login_path, params: { email: user.email, password: 'password' }
    @token = JSON.parse(response.body)['token']
  end

  def auth_headers
    { 'Authorization' => "Bearer #{@token}" }
  end

  test "should get index" do
    get api_v1_ip_geolocations_url, as: :json, headers: auth_headers
    assert_response :success
  end

  test "should create ip_geolocation" do
    assert_difference("IpGeolocation.count") do
      post api_v1_ip_geolocations_url, params: {
        ip_geolocation_params: {
          ip_address: '2.1.2.2'
        }
      }, as: :json, headers: auth_headers
    end

    assert_response :created
  end

  test "should show ip_geolocation" do
    get api_v1_ip_geolocations_url(@ip_geolocation), as: :json, headers: auth_headers
    assert_response :success
  end

  test "should update ip_geolocation" do
    patch api_v1_ip_geolocation_path(@ip_geolocation), headers: auth_headers, params: {
      ip_geolocation_params: {
        ip_address: @ip_geolocation.ip_address, data: @ip_geolocation.data} }, as: :json
    assert_response :success
  end

  test "should destroy ip_geolocation" do
    assert_difference("IpGeolocation.count", -1) do
      delete api_v1_ip_geolocation_path(@ip_geolocation), as: :json, headers: auth_headers
    end

    assert_response :no_content
  end
end
