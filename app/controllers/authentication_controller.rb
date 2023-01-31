class AuthenticationController < ApplicationController

  # POST /login
  def login
    user = User.find_by_username(params[:username])

    if user&.authenticate(params[:password])
      token = JsonWebTokenService.encode(user_id: user.id)
      time = Time.now + 24.hours.to_i
      render json: { token: token, exp: time.strftime("%m-%d-%Y %H:%M"),
                     username: user.username }, status: :ok
    else
      render json: { error: 'Unauthorized. Username or password are wrong' }, status: :unauthorized
    end
  end

  private

  def login_params
    params.permit(:email, :password)
  end
end