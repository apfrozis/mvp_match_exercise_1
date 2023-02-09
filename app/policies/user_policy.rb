# frozen_string_literal: true

class UserPolicy < ApplicationPolicy

  def deposit?
    raise Pundit::NotAuthorizedError, "User has to be Buyer to perform that action" unless user.buyer?

    true
  end


  def buy?
    raise Pundit::NotAuthorizedError, "User has to be Buyer to perform that action" unless user.buyer?

    true
  end

  def reset?
    raise Pundit::NotAuthorizedError, "User has to be Buyer to perform that action" unless user.buyer?

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
end
