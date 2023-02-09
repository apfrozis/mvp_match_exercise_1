class ProductsController < ApplicationController
  before_action :authorize_request, except: [:index]
  #change to policy scope

  def index

    render status: :ok, json: ProductSerializer.collection(Product.all)
  end

  def create
    authorize Product

    product = Product.create!(params.require(:data).permit(:name, :amount_available, :cost)
                                    .merge(user: @current_user))

    render status: :ok, json: ProductSerializer.record(product)
  end

  def destroy
    authorize Product

    product = policy_scope(Product).find_by(id: params.require(:id))
    raise Pundit::NotAuthorizedError, "User cannot perform that action to this product" if product.blank?
    product.destroy

    head :no_content
  end

  def update
    authorize Product

    product = policy_scope(Product).find_by(id: params.require(:id))
    raise Pundit::NotAuthorizedError, "User cannot perform that action to this product" if product.blank?

    product.update!(params.require(:data).permit(:name, :amount_available, :cost))

    render status: :ok, json: ProductSerializer.record(product)
  end
end
