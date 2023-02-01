class ProductsController < ApplicationController
  SELLER_ONLY_ENDPOINTS = [:create, :update, :destroy].freeze
  USER_CREATED_PRODUCT_ONLY_ENDPOINTS = [:update, :destroy].freeze
  before_action :authorize_request, except: [:index]
  before_action :user_is_seller, only: SELLER_ONLY_ENDPOINTS
  before_action :user_created_product, only: USER_CREATED_PRODUCT_ONLY_ENDPOINTS

  def index

    render status: :ok, json: ProductSerializer.collection(Product.all)
  end

  def create
    product = Product.create!(params.require(:data).permit(:name, :amount_available, :cost, :user_id))

    render status: :ok, json: ProductSerializer.record(product)
  end

  def destroy
    Product.destroy(params.require(:id))

    head :no_content
  end

  def update
    product = Product.find(params.require(:id))
    product.update!(params.require(:data).permit(:name, :amount_available, :cost, :user_id))

    render status: :ok, json: ProductSerializer.record(product)
  end

  private

  def user_is_seller
    user = User.seller.find_by(id: @current_user.id)

    raise DepositError, 'User has to be Seller to perform that action' if user.blank?
  end

  def user_created_product
    product = Product.find(params[:id])

    raise DepositError, 'User cannot perform that action to this product' unless product.user_id == @current_user.id
  end
end
