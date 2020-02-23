# frozen_string_literal: true

class Api::V1::OperatorsController < ApplicationController
  before_action :authenticate
  before_action :set_operator, only: %i[ update_operator destroy_operator get_operator ]
  before_action :set_strategy, only: %i[create]
  before_action :set_details, only: %i[create]
  before_action :set_weapons, only: %i[create]

  before_action :is_admin, only: %i[create destroy_operator update_operator]

  def create
    operator = Operator.new(operator_params)
     
     # check count  for strategy maps for operator
      if (Operator.all.where(id: params[:strategy_id]).length >= 5)
        
           render json: { message: "can't add more operator to this strategy, it already has  max  number  of operators " }, status: :bad_request
        elseif(params[:strategy_map_images].length!= 3)
        
          render json: { message: " pls make sure  exactly 3  strategy maps are attached " }, status: :bad_request
         
      end


     #check for strategy map array length
    operator.strategy_id = @strategy.id
    operator.operator_detail_id = @details.id
    operator.weapon_id = @weapon.id 
    # if !params[:summary_images].kind_of?(Array)
    #   render json: { message: " pls make sure  summary_images is an array " }, status: :bad_request
    # elseif !params[:strategy_map_images].kind_of?(Array)
    #     render json: { message: " pls make sure  strategy_map_images is an array " }, status: :bad_request

    # elseif  params[:strategy_map_images].kind_of?(Array)
    #       render json: { message: " pls make sure  sketch image is not an array " }, status: :bad_request
    # end

    puts("********************************************")
    puts("********************************************")
    puts("********************************************")
    puts("********************************************")
    puts("********************************************")
    puts(params)
    puts("********************************************")
    puts("********************************************")
    puts("********************************************")
    puts("********************************************")
    puts("********************************************")
     binding.pry 

    if operator.save
      set_summary_images(operator)
      set_strategy_images(operator)
    
      weapon = operator.weapon
      details = operator.operator_detail

      sketch_image = ""; sketch_image = url_for(operator.sketch_image) if operator.sketch_image.attached?
      logo = ""; logo = url_for(details.logo) if details.logo.attached?

       summary_images = summary_images_urls(operator)
      
       strategy_maps = strategy_maps_urls(operator)
      render json: { operator_id: operator.id, name: details.name, description: details.description, gadget1: weapon.gadget1, gadget2: weapon.gadget2, primary_weapon: weapon.primary_weapon, secondary_weapon: weapon.secondary_weapon, logo: logo, sketch_image: sketch_image, summary_images: summary_images, strategy_maps: strategy_maps }, status: 200
    else
      render json: operator.errors.messages, status: 400
    end
    #this error thrown even when opertor is created  succefully
  rescue StandardError => e
    render json: { message: "this is modified. Error: Something went wrong... " }, status: :bad_request
  end

  def update_operator
    @operator.update(operator_params)
    if @operator.errors.any?
      render json: @operator.errors.messages, status: 400
    else
      set_summary_images(@operator)
      set_strategy_images(@operator)
      
      weapon = @operator.weapon
      details = @operator.operator_detail
      sketch_image = ""; sketch_image = url_for(@operator.sketch_image) if @operator.sketch_image.attached?
      logo = ""; logo = url_for(details.logo) if details.logo.attached?

      summary_images = summary_images_urls(@operator)
      strategy_maps = strategy_maps_urls(@operator)
      render json: { operator_id: @operator.id, name: details.name, description: details.description, gadget1: weapon.gadget1, gadget2: weapon.gadget2, primary_weapon: weapon.primary_weapon, secondary_weapon: weapon.secondary_weapon, logo: logo, sketch_image: sketch_image, summary_images: summary_images, strategy_maps: strategy_maps }, status: 200
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
      strategy_maps = strategy_maps_urls(operator)
      all_operators << { operator_id: operator.id, name: details.name, description: details.description, gadget1: weapon.gadget1, gadget2: weapon.gadget2, primary_weapon: weapon.primary_weapon, secondary_weapon: weapon.secondary_weapon, logo: logo, sketch_image: sketch_image, summary_images: summary_images, strategy_maps: strategy_maps }
    end

    render json: all_operators, status: 200
  rescue StandardError => e
    render json: { message: "Error: Something went wrong... " }, status: :bad_request
  end

  def get_operator
    if @operator.present?
      weapon = @operator.weapon
      details = @operator.operator_detail
      summary_images = summary_images_urls(@operator)
      strategy_maps = strategy_maps_urls(@operator)
      sketch_image = ""; sketch_image = url_for(@operator.sketch_image) if @operator.sketch_image.attached?
      logo = ""; logo = url_for(details.logo) if details.logo.attached?
      render json: { weapon_id: weapon.id, details: details.id, operator_id: @operator.id, name: details.name, description: details.description, gadget1: weapon.gadget1, gadget2: weapon.gadget2, primary_weapon: weapon.primary_weapon, secondary_weapon: weapon.secondary_weapon, logo: logo, sketch_image: sketch_image, summary_images: summary_images, strategy_maps: strategy_maps }, status: 200
    end
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
    params.permit(:sketch_image )
  end

  def is_admin
    if @user.role == "admin"
      true
    else
      render json: { message: "Only admin can create/update/destroy operators!" }
    end
  end

  #this logic should be moved to model

 
  def set_summary_images(operator)
    
    if params[:summary_images].present?
      summary_images = SummaryImage.new()
      summary_images.images.attach(params[:summary_images])
      summary_images.operator_id = operator.id
      summary_images.save
      
    end
  end

  # this logic  should  be moved  to the  model
  
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



  def set_strategy_images(operator)
    if params[:strategy_map_images].present?
      strategy_images = StrategyMap.new()
      strategy_images.images.attach(params[:strategy_map_images])
      strategy_images.operator_id = operator.id
      strategy_images.save
     
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

end
