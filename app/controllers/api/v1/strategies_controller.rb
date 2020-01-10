# frozen_string_literal: true

class Api::V1::StrategiesController < ApplicationController
  before_action :authenticate
  before_action :set_strategy, only: %i[destroy_strategy update_strategy]
  before_action :set_site, only: %i[create]
  before_action :is_admin, only: %i[create destroy_strategy update_strategy]

  def create
    strategy = Strategy.new(strategy_params)
    strategy.site_id = @site.id
    if strategy.save
      image_url = ""
      image_url = url_for(strategy.image) if strategy.image.attached?
      render json: { strategy_id: strategy.id, name: strategy.name, strategy_type: strategy.strategy_type, image: image_url }, status: 200
    else
      render json: strategy.errors.messages, status: 400
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

  private

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
end
