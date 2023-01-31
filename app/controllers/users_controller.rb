class UsersController < ApplicationController

  PERMITTED_DEPOSIT_AMOUNTS = [5, 10, 20, 50, 100].freeze

  before_action :user_is_buyer, only: BUYER_ONLY_ENDPOINTS

  def index

    render status: :ok, json: UserSerializer.collection(User.all)
  end

  # no auth
  def create
    user = User.create!(params.require(:data).permit(:name, :username, :password, :role))

    render status: :ok, json: UserSerializer.record(user)

  end

  def destroy
    User.destroy(params.require(:id))

    render status: :no_content
  end

  def update
    user = User.find(params.require(:id))
    user.update!(params.require(:data).permit(:name, :username, :password, :role))

    render status: :ok, json: UserSerializer.record(user)
  end

  def deposit
    unless PERMITTED_DEPOSIT_AMOUNTS.include?(params.require(:deposit).to_f)
      raise ApplicationController::DepositError, 'Amount not allowed, please deposit 5, 10, 20, 50 and 100 cent'
    end

    current_cash = User.find(params.require(:user_id)).deposit
    user = User.find(params.require(:user_id))
    user.update!(deposit: current_cash + params.require(:deposit).to_f)

    render status: :ok, json: UserSerializer.record(user)
  end

  def buy
    products_amount = params.require(:products_amount).to_i
    product = Product.find(params.require(:product_id))
    user = User.find(params.require(:user_id))

    if not_enough_money_to_buy(user.deposit, product.cost, products_amount)
      raise DepositError, 'Not enough money to buy product/products'
    end

    if not_enough_products_available(product.amount_available, products_amount)
      raise DepositError, 'Not enough products available'
    end

    # Verify if product is decimal and raise in that case
    if products_amount < 0
      raise DepositError, "Amount can't be less than 0"
    end

    amount_spent = product.cost * products_amount
    user.update!(deposit: user.deposit - amount_spent)
    product.update!(amount_available: product.amount_available - products_amount)

    render status: :ok, json: ProductSerializer.record(product).merge(amount_spent: amount_spent)
  end

  def reset
    User.find(params.require(:user_id)).update!(deposit: 0)

    render status: :ok, json: UserSerializer.record(user)
  end

  private

  def not_enough_money_to_buy(user_deposit, product_cost, product_amount)
    user_deposit <= (product_cost * product_amount)
  end

  def not_enough_products_available(product_amount_available, product_amount_requested)
    product_amount_requested > product_amount_available
  end

  def user_is_buyer
    user = User.buyer.find_by(id: params.require(:user_id))

    raise DepositError, 'User has to be Buyer to perform that action' if user.blank?
  end

end
