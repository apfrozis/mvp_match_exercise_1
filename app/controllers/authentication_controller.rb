class AuthenticationController < ApplicationController

  # POST /login
  def login
    user = User.find_by_username(params[:username])

    if user&.authenticate(params[:password])
      raise DepositError, 'There is already an active session using your account' if user_already_logged_in?(user)

      time = 24.hours.from_now
      token = JsonWebTokenService.encode({ user_id: user.id }, time.to_i)
      Session.create(token: token, user: user, expiration_date: time)

      render json: { token: token, exp: time.strftime("%m-%d-%Y %H:%M"),
                     username: user.username }, status: :ok
    else
      render json: { error: 'Unauthorized. Username or password are wrong' }, status: :unauthorized
    end
  end

  # POST /logout
  def logout
    user = User.find_by_username(params[:username])

    unless user&.authenticate(params[:password])
      render json: { error: 'Unauthorized. Username or password are wrong' }, status: :unauthorized
      return
    end

    Session.where(user: user).destroy_all

    render json: { message: 'You have successfully logged out' }, status: :ok
  end

  private

  def login_params
    params.permit(:email, :password)
  end

  def user_already_logged_in?(user)
    Session.find_by(user: user, expiration_date: DateTime.now..).present?
  end
end