# frozen_string_literal: true

class Api::V1::WeaponsController < ApplicationController
  before_action :authenticate
  before_action :set_weapon, only: %i[destroy_weapon update_weapon get_weapon]
  before_action :is_admin, only: %i[create destroy_weapon update_weapon]

  def create
    weapon = Weapon.new(weapon_params)
      
    if weapon.save
      render json: { weapon_id: weapon.id, gadget1: weapon.gadget1, gadget2: weapon.gadget2, primary_weapon: weapon.primary_weapon, secondary_weapon: weapon.secondary_weapon,name: @weapon.name  }, status: 200
    else
      render json: weapon.errors.messages, status: 400
    end
  rescue StandardError => e
    render json: { message: "Error: Something went wrong... " }, status: :bad_request
  end

  def update_weapon
    @weapon.update(weapon_params)
    if @weapon.errors.any?
      render json: @weapon.errors.messages, status: 400
    else
      render json: { weapon_id: @weapon.id, gadget1: @weapon.gadget1, gadget2: @weapon.gadget2, primary_weapon: @weapon.primary_weapon, secondary_weapon: @weapon.secondary_weapon, name: @weapon.name }, status: 200
    end
  rescue StandardError => e
    render json: { message: "Error: Something went wrong... " }, status: :bad_request
  end

  def get_weapon
    if @weapon.present?
      render json: { weapon_id: @weapon.id, gadget1: @weapon.gadget1, gadget2: @weapon.gadget2, primary_weapon: @weapon.primary_weapon, secondary_weapon: @weapon.secondary_weapon,name: @weapon.name  }, status: 200
    end
  rescue StandardError => e
    render json: { message: "Error: Something went wrong... " }, status: :bad_request
  end

  def index
    weapons = Weapon.all; all_weapons = []
    weapons.each do |weapon|
      all_weapons << { weapon_id: weapon.id, gadget1: weapon.gadget1, gadget2: weapon.gadget2, primary_weapon: weapon.primary_weapon, secondary_weapon: weapon.secondary_weapon,name: weapon.name  }
    end
    render json: all_weapons, status: 200
  rescue StandardError => e
    render json: { message: "Error: Something went wrong... " }, status: :bad_request
  end

  def destroy_weapon
    @weapon.destroy
    render json: { message: "weapon deleted successfully!" }, status: 200
  rescue StandardError => e # rescu if any exception occure
    render json: { message: "Error: Something went wrong... " }, status: :bad_request
  end

  private

  def set_weapon # instance methode for weapon
    @weapon = Weapon.find_by_id(params[:weapon_id])
    if @weapon.present?
      return true
    else
      render json: { message: "weapon Not found!" }, status: 404
    end
  end

  def weapon_params
    params.permit(:gadget1, :gadget2, :primary_weapon, :secondary_weapon, :name)
  end

  def is_admin
    if @user.role == "admin"
      true
    else
      render json: { message: "Only admin can create/update/destroy weapons!" }
    end
  end
end
