class ApplicationController < ActionController::Base

  class DepositError < StandardError; end

  rescue_from DepositError do |exception|
    render json: { error: exception.message }, status: :bad_request
  end

  rescue_from StandardError do |exception|
    render json: { error: exception.message }, status: :not_implemented
  end
end
