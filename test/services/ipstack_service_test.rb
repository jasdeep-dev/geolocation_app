# test/services/ipstack_service_test.rb

require 'test_helper'
require 'webmock/minitest'
require_relative '../../app/services/ipstack_service'

class IPStackServiceTest < ActiveSupport::TestCase
  setup do
    @ip = '134.201.250.155'
    @apiKey = 'IPSTACK_API_KEY'  # Replace with your actual IPStack API key
    @service = IPStackService.new(@ip)
  end

  test 'should return geolocation data when the request is successful' do
    response_body = {
      ip: '134.201.250.155',
      type: 'ipv4',
      continent_code: 'NA',
      continent_name: 'North America',
      country_code: 'US',
      country_name: 'United States',
      region_code: 'CA',
      region_name: 'California',
      city: 'Los Angeles',
      zip: '90001',
      latitude: 34.05223,
      longitude: -118.24368
  }.to_json

    stub_request(:get, "https://api.ipgeolocation.io/ipgeo?ip=#{@ip}")
      .with(query: { apiKey: @apiKey })
      .to_return(status: 200, body: response_body, headers: {})

    data = @service.fetch_data
    data = JSON.parse(data)
    assert_equal '134.201.250.155', data['ip']
    assert_equal 'United States', data['country_name']
    assert_equal 'Los Angeles', data['city']
  end

  test 'should raise an error when the request fails' do
    stub_request(:get, "https://api.ipgeolocation.io/ipgeo?ip=#{@ip}")
      .with(query: { apiKey: @apiKey })
      .to_return(status: 500, body: 'Internal Server Error', headers: {})

    assert_raises RuntimeError do
      @service.fetch_data
    end
  end

  test 'should raise an error when the response body is nil' do
    stub_request(:get, "https://api.ipgeolocation.io/ipgeo?ip=#{@ip}")
      .with(query: { apiKey: @apiKey })
      .to_return(status: 200, body: nil, headers: {})

    assert_raises RuntimeError do
      @service.fetch_data
    end
  end

  test 'should raise an error when the response body is empty' do
    stub_request(:get, "https://api.ipgeolocation.io/ipgeo?ip=#{@ip}")
      .with(query: { apiKey: @apiKey })
      .to_return(status: 200, body: '', headers: {})

    assert_raises RuntimeError do
      @service.fetch_data
    end
  end
end
