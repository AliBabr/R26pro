# frozen_string_literal: true
# PperatorDetailsController
class Api::V1::OperatorDetailsController < ApplicationController
  before_action :authenticate
  before_action :set_detail, only: %i[destroy_detail update_detail]
  before_action :is_admin, only: %i[create destroy_detail update_detail]

  def create
    detail = OperatorDetail.new(detail_params)
    if detail.save
      logo_url = ""
      logo_url = url_for(detail.logo) if detail.logo.attached?
      render json: { operator_detail_id: detail.id, name: detail.name, description: detail.description, logo: logo_url }, status: 200
    else
      render json: detail.errors.messages, status: 400
    end
  rescue StandardError => e
    render json: { message: "Error: Something went wrong... " }, status: :bad_request
  end

  def update_detail
    @detail.update(detail_params)
    if @detail.errors.any?
      render json: @detail.errors.messages, status: 400
    else
      logo_url = ""
      logo_url = url_for(@detail.logo) if @detail.logo.attached?
      render json: { operator_detail_id: @detail.id, name: @detail.name, description: @detail.description, logo: logo_url }, status: 200
    end
  rescue StandardError => e
    render json: { message: "Error: Something went wrong... " }, status: :bad_request
  end

  def index
    details = OperatorDetail.all; all_details = []
    details.each do |detail|
      logo_url = ""
      logo_url = url_for(detail.logo) if detail.logo.attached?
      all_details << { operator_detail_id: detail.id, name: detail.name, description: detail.description, logo: logo_url }
    end
    render json: all_details, status: 200
  rescue StandardError => e
    render json: { message: "Error: Something went wrong... " }, status: :bad_request
  end

  def destroy_detail
    @detail.destroy
    render json: { message: "detail deleted successfully!" }, status: 200
  rescue StandardError => e # rescu if any exception occure
    render json: { message: "Error: Something went wrong... " }, status: :bad_request
  end

  private

  def set_detail # instance methode for detail
    @detail = OperatorDetail.find_by_id(params[:operator_detail_id])
    if @detail.present?
      return true
    else
      render json: { message: "detail Not found!" }, status: 404
    end
  end

  def detail_params
    params.permit(:name, :description, :logo)
  end

  def is_admin
    if @user.role == "admin"
      true
    else
      render json: { message: "Only admin can create/update/destroy details!" }
    end
  end
end
