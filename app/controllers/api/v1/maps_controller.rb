# frozen_string_literal: true

class Api::V1::MapsController < ApplicationController
  before_action :authenticate
  before_action :set_map, only: %i[destroy_map update_map]
  before_action :is_admin, only: %i[create destroy_map update_map]

  def create
    map = Map.new(map_params)
    if map.save
      image_url = ""
      image_url = url_for(map.image) if map.image.attached?
      render json: { map_id: map.id, name: map.name, image: image_url }, status: 200
    else
      render json: map.errors.messages, status: 400
    end
  rescue StandardError => e
    render json: { message: "Error: Something went wrong... " }, status: :bad_request
  end

  def update_map
    @map.update(map_params)
    if @map.errors.any?
      render json: @map.errors.messages, status: 400
    else
      image_url = ""
      image_url = url_for(@map.image) if @map.image.attached?
      render json: { message: "Error: Something went wrong... " }, status: :bad_request
      render json: { map_id: map.id, name: map.name, image: image_url }, status: 200
    end
  rescue StandardError => e
    render json: { message: "Error: Something went wrong... " }, status: :bad_request
  end

  def index
    maps = map.all; all_maps = []
    maps.each do |map|
      image_url = ""
      image_url = url_for(map.image) if map.image.attached?
      all_maps << { map_id: map.id, name: map.name, image: image_url }
    end
    render json: all_maps, status: 200
  rescue StandardError => e
    render json: { message: "Error: Something went wrong... " }, status: :bad_request
  end

  def destroy_map
    @map.destroy
    render json: { message: "map deleted successfully!" }, status: 200
  rescue StandardError => e # rescu if any exception occure
    render json: { message: "Error: Something went wrong... " }, status: :bad_request
  end

  private

  def set_map # instance methode for map
    @map = Map.find_by_id(params[:map_id])
    if @map.present?
      return true
    else
      render json: { message: "map Not found!" }, status: 404
    end
  end

  def map_params
    params.permit(:name, :image)
  end

  def is_admin
    if @user.role == "admin"
      true
    else
      render json: { message: "Only admin can create/update/destroy maps!" }
    end
  end
end
