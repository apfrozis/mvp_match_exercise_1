class ProductsController < ApplicationController
  before_action :authorize_request, except: [:index]

  before_action :user_is_seller, only: SELLER_ONLY_ENDPOINTS


  #no auth
  def index

    render status: :ok, json: ProductSerializer.collection(Product.all)
  end

  # no auth
  def create
    product = Product.create!(params.require(:data).permit(:name, :amount_available, :cost, :user_id))

    render status: :ok, json: ProductSerializer.record(product)

  end

  def destroy
    Product.destroy!(params.require(:id))

    render status: :no_content
  end

  def update
    product = Product.find(params.require(:id)).update!(params.require(:data).permit(:name, :amount_available, :cost, :user_id))

    render status: :ok, json: ProductSerializer.record(product)
  end

  private

  def user_is_seller
    user = User.seller.find_by(id: params.require(:user_id))


    raise DepositError, 'User has to be Seller to perform that action' if user.blank?
  end
end
