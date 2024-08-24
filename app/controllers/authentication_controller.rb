class AuthenticationController < ApplicationController
  skip_before_action :authenticate_user!

  def signup
    return unless have_required_params(:email, :name, :password, :password_confirmation)
    return unless password_confirmation_match

    user = User.new(user_params)

    if user.save
      render json: { token: user.auth_token }, status: :created
    else
      render_errors(user, status: :unprocessable_entity)
    end
  end

  def login
    return unless have_required_params(:email, :password)

    user = User.find_by_email(login_params[:email])

    if user&.authenticate(login_params[:password])
      render json: { token: user.auth_token }, status: :ok
    else
      render_errors('Invalid email or password', status: :unauthorized)
    end
  end

  private

  def user_params
    params.permit(:email, :name, :password)
  end
  
  def login_params
    params.permit(:email, :password)
  end

  def have_required_params(*keys)
    missing_keys = []

    keys.each do |key|
      if params[key].blank?
        missing_keys << key
      end
    end

    return true if missing_keys.empty?

    render_errors("Missing required parameters: #{missing_keys.join(', ')}", status: :unprocessable_entity)

    false
  end

  def password_confirmation_match
    return true if params[:password] == params[:password_confirmation]  

    render_errors('Password and password confirmation do not match', status: :unprocessable_entity)

    false
  end
end
