# frozen_string_literal: true

class Api::V1::OperatorsController < ApplicationController
  before_action :authenticate
  before_action :set_operator, only: %i[ update_operator destroy_operator ]
  before_action :set_strategy, only: %i[create]
  before_action :set_details, only: %i[create]
  before_action :set_weapons, only: %i[create]

  before_action :is_admin, only: %i[create destroy_operator update_operator]

  def create
    operator = Operator.new(operator_params)
    operator.strategy_id = @strategy.id
    operator.operator_detail_id = @details.id
    operator.weapon_id = @weapon.id

    if operator.save
      set_summary_images(operator)
      weapon = operator.weapon
      details = operator.operator_detail
      sketch_image = ""; sketch_image = url_for(operator.sketch_image) if operator.sketch_image.attached?
      logo = ""; logo = url_for(details.logo) if details.logo.attached?
      summary_images = summary_images_urls(operator)
      render json: { operator_id: operator.id, name: details.name, description: details.description, gadget1: weapon.gadget1, gadget2: weapon.gadget2, primary_weapon: weapon.primary_weapon, secondary_weapon: weapon.secondary_weapon, logo: logo, sketch_image: sketch_image, summary_images: summary_images }, status: 200
    else
      render json: operator.errors.messages, status: 400
    end
  rescue StandardError => e
    render json: { message: "Error: Something went wrong... " }, status: :bad_request
  end

  def update_operator
    @operator.update(operator_params)
    if @operator.errors.any?
      render json: @operator.errors.messages, status: 400
    else
      set_summary_images(@operator)
      weapon = @operator.weapon
      details = @operator.operator_detail
      sketch_image = ""; sketch_image = url_for(@operator.sketch_image) if @operator.sketch_image.attached?
      logo = ""; logo = url_for(details.logo) if details.logo.attached?
      summary_images = summary_images_urls(@operator)
      render json: { operator_id: @operator.id, name: details.name, description: details.description, gadget1: weapon.gadget1, gadget2: weapon.gadget2, primary_weapon: weapon.primary_weapon, secondary_weapon: weapon.secondary_weapon, logo: logo, sketch_image: sketch_image, summary_images: summary_images }, status: 200
    end
  rescue StandardError => e
    render json: { message: "Error: Something went wrong... " }, status: :bad_request
  end

  def index
    operators = Operator.all; all_operators = []
    operators.each do |operator|
      weapon = operator.weapon
      details = operator.operator_detail
      sketch_image = ""; sketch_image = url_for(operator.sketch_image) if operator.sketch_image.attached?
      logo = ""; logo = url_for(details.logo) if details.logo.attached?
      summary_images = summary_images_urls(operator)
      all_operators << { operator_id: operator.id, name: details.name, description: details.description, gadget1: weapon.gadget1, gadget2: weapon.gadget2, primary_weapon: weapon.primary_weapon, secondary_weapon: weapon.secondary_weapon, logo: logo, sketch_image: sketch_image, summary_images: summary_images }
    end
    render json: all_operators, status: 200
  rescue StandardError => e
    render json: { message: "Error: Something went wrong... " }, status: :bad_request
  end

  def destroy_operator
    @operator.destroy
    render json: { message: "operator deleted successfully!" }, status: 200
  rescue StandardError => e # rescu if any exception occure
    render json: { message: "Error: Something went wrong... " }, status: :bad_request
  end

  private

  def set_operator # instance methode for operator
    @operator = Operator.find_by_id(params[:operator_id])
    if @operator.present?
      return true
    else
      render json: { message: "operator Not found!" }, status: 404
    end
  end

  def set_strategy
    @strategy = Strategy.find_by_id(params[:strategy_id])
    if @strategy.present?
      return true
    else
      render json: { message: "please provide valid strategy id..!" }, status: 404
    end
  end

  def set_details
    @details = OperatorDetail.find_by_id(params[:operator_detail_id])
    if @details.present?
      return true
    else
      render json: { message: "please provide valid operator detail id..!" }, status: 404
    end
  end

  def set_weapons
    @weapon = Weapon.find_by_id(params[:weapon_id])
    if @weapon.present?
      return true
    else
      render json: { message: "please provide valid weapon id..!" }, status: 404
    end
  end

  def operator_params
    params.permit(:sketch_image)
  end

  def is_admin
    if @user.role == "admin"
      true
    else
      render json: { message: "Only admin can create/update/destroy operators!" }
    end
  end

  def set_summary_images(operator)
    summary_images = SummaryImage.new()
    images = params[:summary_images].values
    summary_images.images = images
    summary_images.operator_id = operator.id
    summary_images.save
  end

  def summary_images_urls(operator)
    images = []
    if operator.summary_image.images.attached?
      operator.summary_image.images.each do |photo|
        images << url_for(photo)
      end
    end
    images
  end

  def set_sketch_image(operator)
    sketch_image = Sketch.new(sketch_image: params[:sketch_image])
    sketch_image.operator_id = operator.id
    sketch_image.save
  end

  def sketch_image_url(operator)
    sketch_image = ""
    sketch_image = url_for(operator.sketch.sketch_image) if operator.sketch.sketch_image.attached?
    return sketch_image
  end
end
