class ApplicationController < ActionController::Base
  protect_from_forgery prepend: true

  class DepositError < StandardError; end

  BUYER_ONLY_ENDPOINTS = [:deposit, :buy, :reset].freeze

  SELLER_ONLY_ENDPOINTS = [:create, :update, :destroy].freeze

  rescue_from DepositError do |exception|
    render json: { error: exception.message }, status: :bad_request
  end

  def not_found
    render json: { error: 'not_found' }
  end

  def authorize_request
    byebug
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    begin
      @decoded = JsonWebTokenService.decode(header)
      @current_user = User.find(@decoded[:user_id])
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { errors: e.message }, status: :unauthorized
    end
  end


end
