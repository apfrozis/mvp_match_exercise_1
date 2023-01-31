class ProductsController < ApplicationController

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
end
