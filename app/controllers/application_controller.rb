class ApplicationController < ActionController::Base

  class DepositError < StandardError; end

  rescue_from ApplicationController::DepositError do |exception|
    render json: { error: exception.message }, status: :bad_request
  end


end
