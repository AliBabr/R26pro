# frozen_string_literal: true

class Api::V1::StrategiesController < ApplicationController
  before_action :authenticate
  before_action :set_strategy, only: %i[destroy_strategy update_strategy get_strategy get_strategy_operators]
  before_action :set_site, only: %i[create]
  before_action :is_admin, only: %i[create destroy_strategy update_strategy]
  before_action :get_operators, only: %i[create]

  def create
    strategy = Strategy.new(strategy_params)
    strategy.site_id = @site.id
    if strategy.save
      assign_operators(strategy)
      image_url = ""
      image_url = url_for(strategy.image) if strategy.image.attached?
      render json: { strategy_id: strategy.id, name: strategy.name, strategy_type: strategy.strategy_type, image: image_url, operators: strategy.operators }, status: 200
    else
      render json: strategy.errors.messages, statusoperator_array: 400
    end
  rescue StandardError => e
    render json: { message: "Error: Something went wrong... " }, status: :bad_request
  end

  def get_strategy
    if @strategy.present?
      image_url = ""
      image_url = url_for(@strategy.image) if @strategy.image.attached?
      render json: { site_id: @strategy.site_id, strategy_id: @strategy.id, name: @strategy.name, strategy_type: @strategy.strategy_type, image: image_url }, status: 200
    else
      render json: { error: "staregy not found" }, status: 400
    end
  rescue StandardError => e
    render json: { message: "Error: Something went wrong... " }, status: :bad_request
  end

  def update_strategy
    @strategy.update(strategy_params)
    if @strategy.errors.any?
      render json: @strategy.errors.messages, status: 400
    else
      image_url = ""
      image_url = url_for(@strategy.image) if @strategy.image.attached?
      render json: { strategy_id: @strategy.id, name: @strategy.name, strategy_type: @strategy.strategy_type, image: image_url }, status: 200
    end
  rescue StandardError => e
    render json: { message: "Error: Something went wrong... " }, status: :bad_request
  end

  def index
    strategys = Strategy.all; all_strategys = []
    strategys.each do |strategy|
      image_url = ""
      image_url = url_for(strategy.image) if strategy.image.attached?
      all_strategys << { strategy_id: strategy.id, name: strategy.name, strategy_type: strategy.strategy_type, image: image_url }
    end
    render json: all_strategys, status: 200
  rescue StandardError => e
    render json: { message: "Error: Something went wrong... " }, status: :bad_request
  end

  def destroy_strategy
    @strategy.destroy
    render json: { message: "strategy deleted successfully!" }, status: 200
  rescue StandardError => e # rescu if any exception occure
    render json: { message: "Error: Something went wrong... " }, status: :bad_request
  end

  def get_operators
    operators = Operator.all.where(strategy_id: params[:id])
    all_operators = []
    operators.each do |op|
      weapon = op.weapon
      details = op.operator_detail

      summary_images = summary_images_urls(op)
      strategy_maps = strategy_maps_urls(op)
      sketch_image = ""; sketch_image = url_for(op.sketch_image) if op.sketch_image.attached?
      logo = ""; logo = url_for(details.logo) if details.logo.attached?
      all_operators << { weapon_id: weapon.id, details: details.id, operator_id: op.id, name: details.name, description: details.description, gadget1: weapon.gadget1, gadget2: weapon.gadget2, primary_weapon: weapon.primary_weapon, secondary_weapon: weapon.secondary_weapon, logo: logo, sketch_image: sketch_image, summary_images: summary_images, strategy_maps: strategy_maps }
    end
    render json: all_operators, status: 200
  end

  def get_strategy_operators
    all_operators = []
    @strategy.operators.each do |operator|
      weapon = operator.weapon
      details = operator.operator_detail
      sketch_image = ""; sketch_image = url_for(operator.sketch_image) if operator.sketch_image.attached?
      logo = ""; logo = url_for(details.logo) if details.logo.attached?
      summary_images = summary_images_urls(operator)
      strategy_maps = strategy_maps_urls(operator)
      all_operators << { operator_id: operator.id, name: details.name, description: details.description, gadget1: weapon.gadget1, gadget2: weapon.gadget2, primary_weapon: weapon.primary_weapon, secondary_weapon: weapon.secondary_weapon, logo: logo, sketch_image: sketch_image, summary_images: summary_images, strategy_maps: strategy_maps }
    end
    render json: all_operators, status: 200
  rescue StandardError => e
    render json: { message: "Error: Something went wrong... " }, status: :bad_request
  end

  private

  def summary_images_urls(operator)
    images = []
    if operator.summary_image.present?
      if operator.summary_image.images.attached?
        operator.summary_image.images.each do |photo|
          images << url_for(photo)
        end
      end
    end
    images
  end

  def strategy_maps_urls(operator)
    images = []
    if operator.strategy_map.present?
      if operator.strategy_map.images.attached?
        operator.strategy_map.images.each do |photo|
          images << url_for(photo)
        end
      end
    end
    images
  end

  def set_strategy # instance methode for strategy
    @strategy = Strategy.find_by_id(params[:strategy_id])
    if @strategy.present?
      return true
    else
      render json: { message: "strategy Not found!" }, status: 404
    end
  end

  def set_site
    @site = Site.find_by_id(params[:site_id])
    if @site.present?
      return true
    else
      render json: { message: "please provide valid site id..!" }, status: 404
    end
  end

  def strategy_params
    params.permit(:name, :image, :strategy_type)
  end

  def is_admin
    if @user.role == "admin"
      true
    else
      render json: { message: "Only admin can create/update/destroy strategys!" }
    end
  end

  def assign_operators(strategy)
    @operators.each do |op|
      strategy.operators << op
    end
  end

  def get_operators
    if params[:operator_array].present? && params[:operator_array].values.count == 5
      operators = params[:operator_array].values
      @operators = []
      operators.each do |id|
        if Operator.find_by_id(id).present?
          @operators << Operator.find_by_id(id)
        end
      end
      if @operators.count == 5
        return true
      else
        render json: { message: "Please provide exact 5 valid operators..!" }, status: 404
      end
    else
      render json: { message: "Please provide exact 5 operators..!" }, status: 404
    end
  end

  def strategy_maps_urls(operator)
    images = []
    if operator.strategy_map.present?
      if operator.strategy_map.images.attached?
        operator.strategy_map.images.each do |photo|
          images << url_for(photo)
        end
      end
    end
    images
  end

  def summary_images_urls(operator)
    images = []
    if operator.summary_image.present?
      if operator.summary_image.images.attached?
        operator.summary_image.images.each do |photo|
          images << url_for(photo)
        end
      end
    end
    images
  end
end
