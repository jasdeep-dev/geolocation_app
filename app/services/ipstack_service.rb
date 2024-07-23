# app/services/ipstack_service.rb

require 'httparty'

class IPStackService
  include HTTParty
  base_uri 'https://api.ipgeolocation.io'

  def initialize(ip)
    @ip = ip
    @api_key = ENV['IPSTACK_API_KEY'] || "IPSTACK_API_KEY"  # It's best practice to use environment variables for API keys
  end

  def fetch_data
    response = self.class.get('/ipgeo', query: { apiKey: @api_key, ip: @ip })

    if response.success? && !(response.body.nil? || response.body.empty?) && response['ip']
      response.parsed_response
    else
      raise "Error fetching data from IPStack: #{response.message}"
    end
  end

  def store_data
    response = self.class.get('/ipgeo', query: { apiKey: @api_key, ip: @ip })

    if response.success? && !(response.body.nil? || response.body.empty?) && response['ip']
      save_data(response)
    else
      raise "Error fetching data from IPStack: #{response.message}"
    end
  end

  private

  def save_data(response)
    IpGeolocation.create!(ip_address: response['ip'], data: response)
  end
end
