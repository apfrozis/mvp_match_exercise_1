# frozen_string_literal: true

class ProductPolicy < ApplicationPolicy

  def create?
    raise Pundit::NotAuthorizedError, "User has to be Seller to perform that action" unless user_seller?

    true
  end

  def update?
    raise Pundit::NotAuthorizedError, "User has to be Seller to perform that action" unless user_seller?

    true
  end

  def destroy?
    raise Pundit::NotAuthorizedError, "User has to be Seller to perform that action" unless user_seller?

    true
  end

  class Scope < ApplicationPolicy
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      @scope.where(user: @user)
    end

  end

  private

  def user_seller?
    user.role == 'seller'
  end
end
