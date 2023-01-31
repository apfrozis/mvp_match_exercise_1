class ApplicationController < ActionController::Base

  class DepositError < StandardError; end

  BUYER_ONLY_ENDPOINTS = [:deposit, :buy, :reset].freeze

  SELLER_ONLY_ENDPOINTS = [:create, :update, :destroy].freeze

  rescue_from DepositError do |exception|
    render json: { error: exception.message }, status: :bad_request
  end


end
