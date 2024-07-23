require_relative '../../../services/ipstack_service'
class Api::V1::IpGeolocationsController < ApplicationController
  include Authenticatable
  before_action :set_ip_geolocation, only: %i[ show update destroy ]
  before_action :check_current_user
  # GET /ip_geolocations
  def index
    @ip_geolocations = IpGeolocation.all

    render json: @ip_geolocations
  end

  def search
    if params[:ip_address].empty?
      render json: { error: "Address missing" }, status: :bad_request
      return
    end

    service = IPStackService.new(params[:ip_address])
    @ip_geolocation = service.fetch_data
    render json: @ip_geolocation
  rescue StandardError => e
    render json: { error: e.message }, status: :bad_request
  end

  def show
    if @ip_geolocation
      render json: @ip_geolocation, status: :ok
    else
      render json: @ip_geolocation.errors, status: :unprocessable_entity
    end
  end

  # POST /ip_geolocations
  def create
    service = IPStackService.new(ip_geolocation_params[:ip_address])

    response = service.store_data

    render json: { message: "Data saved successfully" }, status: :created
  rescue StandardError => e
    render json: { error: e }, status: :bad_request
  end

  # # PATCH/PUT /ip_geolocations/1
  def update
    if @ip_geolocation.update(ip_geolocation_params)
      render json: { message: "Data updated successfully" }, status: :ok
    else
      render json: @ip_geolocation.errors, status: :unprocessable_entity
    end
  end

  # # DELETE /ip_geolocations/1
  def destroy
    @ip_geolocation.destroy!
  rescue StandardError => e
    render json: { error: e }, status: :bad_request
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ip_geolocation
      @ip_geolocation = IpGeolocation.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def ip_geolocation_params
      params.require(:ip_geolocation_params).permit(:ip_address, data: {})
    end

    # Check if the user is authorized or not
    def check_current_user
      unless @current_user
        render json: { error: "User is unauthorized" }, status: :unauthorized
      end
    end
end
