class ApplicationController < ActionController::API
  before_action :authenticate_user!

  def authenticate_user!
    @current_user = authorize_request

    render json: { error: 'Unauthorized' }, status: :unauthorized unless current_user
  end

  def current_user
    @current_user
  end

  def paginate(collection)
    collection.page(params[:page]).per(params[:per_page])
  end

  private

  def authorize_request
    token = request.headers['Authorization']

    begin
      decoded = AuthenticationTokenService.decode(token)
      
      User.find(decoded[:user_id])
    rescue ActiveRecord::RecordNotFound, JWT::DecodeError, JWT::VerificationError
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end
end
