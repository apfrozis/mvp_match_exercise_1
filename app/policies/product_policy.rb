# frozen_string_literal: true

class ProductPolicy < ApplicationPolicy

  def create?
    raise Pundit::NotAuthorizedError, "User has to be Seller to perform that action" unless user_seller?

    user_seller?
  end

  def update?
    raise Pundit::NotAuthorizedError, "User has to be Seller to perform that action" unless user_seller?

    user_seller?
  end

  def destroy?
    raise Pundit::NotAuthorizedError, "User has to be Seller to perform that action" unless user_seller?

    user_seller?
  end

  private

  def user_seller?
    user.role == 'seller'
  end
end
