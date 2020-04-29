class UsersController < ApplicationController
  skip_before_action :authenticate_request!, only: %i[create login]

  def create
    user = User.new(user_params.except(:confirm_password))

    user_params = params[:user]
    if user_params[:password] != user_params[:confirm_password]
      render json: { error: 'Passwords don\'t match' }, status: :bad_request
    elsif user.save
      Account.new(account_params(user)).save
      render json: { message: 'User created successfully' }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :bad_request
    end
  end

  def login
    puts params
    user = User.find_by(email: params[:email].to_s.downcase)
    puts user
    if user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: user.id)
      render json: { token: token }, status: :ok
    else
      render json: { error: 'Invalid email/ password' }, status: :unauthorized
    end
  end

  private

  def account_params(user)
    {
        user_id: user.id,
        role: 'Client',
        address: 'Input Address'
    }
  end

  def user_params
    params.require(:user).permit(:username, :email, :password, :confirm_password)
  end
end
