class UsersController < ApplicationController
  BUYER_ONLY_ENDPOINTS = [:deposit, :buy, :reset].freeze
  PERMITTED_DEPOSIT_AMOUNTS = [100, 50, 20, 10, 5].freeze
  before_action :authorize_request, except: :create

  skip_before_action :verify_authenticity_token

  def index

    render status: :ok, json: UserSerializer.collection(User.all)
  end

  # no auth
  def create
    # Validate password - number of chars, special_chars, etc
    user = User.create!(params.require(:data).permit(:name, :username, :password, :role))

    render status: :ok, json: UserSerializer.record(user)

  end

  def destroy
    User.destroy(@current_user.id)

    render status: :no_content
  end

  def update
    # get id from current_user or get id from params and create a policy scope
    user = User.find(@current_user.id)
    user.update!(params.require(:data).permit(:name, :username, :password, :role))

    render status: :ok, json: UserSerializer.record(user)
  end

  def deposit
    authorize User
    # get id from current_user or get id from params and create a policy scope
    unless PERMITTED_DEPOSIT_AMOUNTS.include?(params.require(:deposit).to_f)
      raise ApplicationController::DepositError, 'Amount not allowed, please deposit 5, 10, 20, 50 and 100 cent'
    end

    current_cash = User.find(@current_user.id).deposit.to_f
    user = User.find(@current_user.id)
    user.update!(deposit: current_cash + params.require(:deposit).to_f)

    render status: :ok, json: UserSerializer.record(user)
  end

  #change to service
  def buy
    authorize User

    # get id from current_user or get id from params and create a policy scope
    products_amount = params.require(:products_amount).to_i
    product = Product.find(params.require(:product_id))
    user = User.find(@current_user.id)

    if not_enough_money_to_buy(user.deposit, product.cost, products_amount)
      raise DepositError, 'Not enough money to buy product/products'
    end

    if not_enough_products_available(product.amount_available, products_amount)
      raise DepositError, 'Not enough products available'
    end

    # Verify if products_amount is decimal and raise in that case
    if products_amount < 0
      raise DepositError, "Amount can't be less than 0"
    end

    amount_spent = product.cost * products_amount
    user.update!(deposit: user.deposit - amount_spent)
    product.update!(amount_available: product.amount_available - products_amount)
    render status: :ok, json: ProductSerializer.record(product).merge(amount_spent: amount_spent,
                                                                      change: calculate_change(user.deposit))
  end

  def reset
    user = User.find(@current_user.id)
    # get id from current_user or get id from params and create a policy scope
    user.update!(deposit: 0)

    render status: :ok, json: UserSerializer.record(user)
  end

  private

  def not_enough_money_to_buy(user_deposit, product_cost, product_amount)
    user_deposit <= (product_cost * product_amount)
  end

  def not_enough_products_available(product_amount_available, product_amount_requested)
    product_amount_requested > product_amount_available
  end

  def calculate_change(deposit)
    change_coins = []
    PERMITTED_DEPOSIT_AMOUNTS.each do |permitted_amount|
      if deposit >= permitted_amount
        change_coins << permitted_amount
        remaining_change = deposit - permitted_amount
        return change_coins + calculate_change(remaining_change)
      end
    end
    change_coins
  end

end
