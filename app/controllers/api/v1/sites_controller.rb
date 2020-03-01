# frozen_string_literal: true

class Api::V1::SitesController < ApplicationController
  before_action :authenticate
  before_action :set_site, only: %i[destroy_site update_site get_site get_site_strategies]
  before_action :set_map, only: %i[create]
  before_action :is_admin, only: %i[create destroy_site update_site]

  def create
    site = Site.new(site_params)
    site.map_id = @map.id
    if site.save
      image_url = ""
      image_url = url_for(site.image) if site.image.attached?
      render json: { site_id: site.id, name: site.name, image: image_url }, status: 200
    else
      render json: site.errors.messages, status: 400
    end
  rescue StandardError => e
    render json: { message: "Error: Something went wrong... " }, status: :bad_request
  end

  def update_site
    @site.update(site_params)
    if @site.errors.any?
      render json: @site.errors.messages, status: 400
    else
      image_url = ""
      image_url = url_for(@site.image) if @site.image.attached?
      render json: { site_id: @site.id, name: @site.name, image: image_url }, status: 200
    end
  rescue StandardError => e
    render json: { message: "Error: Something went wrong... " }, status: :bad_request
  end

  def index
    sites = Site.all; all_sites = []
    sites.each do |site|
      image_url = ""
      image_url = url_for(site.image) if site.image.attached?
      all_sites << { site_id: site.id, name: site.name, image: image_url }
    end
    render json: all_sites, status: 200
  rescue StandardError => e
    render json: { message: "Error: Something went wrong... " }, status: :bad_request
  end

  def get_site
    if @site.present?
      image_url = ""
      image_url = url_for(@site.image) if @site.image.attached?
      render json: { site_id: @site.id, name: @site.name, image: image_url, map_id: @site.map.id }, status: 200
    else
      render json: { error: "staregy not found" }, status: 400
    end
  rescue StandardError => e
    render json: { message: "Error: Something went wrong... " }, status: :bad_request
  end

  def destroy_site
    @site.destroy
    render json: { message: "site deleted successfully!" }, status: 200
  rescue StandardError => e # rescu if any exception occure
    render json: { message: "Error: Something went wrong... " }, status: :bad_request
  end

  def get_site_strategies
    @strategies = []
    @site.strategies.each do |strategy|
      image_url = ""
      image_url = url_for(strategy.image) if strategy.image.attached?
      @strategies << { strategy_id: strategy.id, name: strategy.name, strategy_type: strategy.strategy_type, image: image_url }
    end
    render json: { strategies: @strategies }, status: 200
  rescue StandardError => e # rescu if any exception occure
    render json: { message: "Error: Something went wrong... " }, status: :bad_request
  end

  private

  def set_site # instance methode for site
    @site = Site.find_by_id(params[:site_id])
    if @site.present?
      return true
    else
      render json: { message: "site Not found!" }, status: 404
    end
  end

  def set_map
    @map = Map.find_by_id(params[:map_id])
    if @map.present?
      return true
    else
      render json: { message: "please provide valid map id..!" }, status: 404
    end
  end

  def site_params
    params.permit(:name, :image)
  end

  def is_admin
    if @user.role == "admin"
      true
    else
      render json: { message: "Only admin can create/update/destroy sites!" }
    end
  end
end
