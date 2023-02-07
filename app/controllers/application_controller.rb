class ApplicationController < ActionController::Base
  protect_from_forgery prepend: true
  include Pundit::Authorization

  class DepositError < StandardError; end

  rescue_from StandardError do |exception|
    render json: { error: exception.message }, status: :not_implemented
  end

  rescue_from Pundit::NotAuthorizedError do |exception|
    render json: { error: exception.message }, status: :unauthorized
  end

  rescue_from DepositError do |exception|
    render json: { error: exception.message }, status: :bad_request
  end

  def not_found
    render json: { error: 'not_found' }
  end

  def authorize_request
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

  def current_user
    @current_user
  end
end
