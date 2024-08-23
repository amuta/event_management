class AuthenticationController < ApplicationController
  PASSWORD_MIN_LENGTH = 6

  before_action :validate_email
  before_action :validate_password, only: :signup

  def signup
    user = User.new(user_params)
    if user.save
      render json: { token: user.auth_token }, status: :created
    else
      render json: { error: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def login
    user = User.find_by_email(user_params[:email])

    if user&.authenticate(user_params[:password])
      render json: { token: user.auth_token }, status: :ok
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end

  def validate_email
    email = user_params[:email]

    return if email =~ URI::MailTo::EMAIL_REGEXP

    render json: { error: 'Invalid email format' }, status: :unprocessable_entity
  end

  def validate_password
    password = user_params[:password]
    
    return if password.present? && password.length >= PASSWORD_MIN_LENGTH

    render json: { error: 'Password must be at least 6 characters long' }, status: :unprocessable_entity
  end
end
