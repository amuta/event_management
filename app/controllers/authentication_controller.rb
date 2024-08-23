class AuthenticationController < ApplicationController
  def signup
    return unless have_required_params(:email, :name, :password, :password_confirmation)
    return unless password_confirmation_match

    user = User.new(user_params)

    if user.save
      render json: { token: user.auth_token }, status: :created
    else
      render json: { error: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def login
    return unless have_required_params(:email, :password)

    user = User.find_by_email(login_params[:email])

    if user&.authenticate(login_params[:password])
      render json: { token: user.auth_token }, status: :ok
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
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
    keys.each do |key|
      if params[key].blank?
        render json: { error: "#{key.to_s.humanize} is required" }, status: :unprocessable_entity
        return false
      end
    end

    true
  end

  def password_confirmation_match
    return true if params[:password] == params[:password_confirmation]  

    render json: { error: 'Password and password confirmation do not match' }, status: :unprocessable_entity

    false
  end
end
