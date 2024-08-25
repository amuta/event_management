class ApplicationController < ActionController::API
  before_action :authenticate_user!

  def authenticate_user!
    @current_user = authorize_request

    @current_user_roles = @current_user&.roles || Role.none

    return if @current_user

    render_errors('Unauthorized', status: :unauthorized)
  end

  attr_reader :current_user, :current_user_roles

  def paginate(collection)
    collection.page(params[:page]).per(params[:per_page])
  end

  private

  def authorize_request
    token = request.headers['Authorization']&.split(' ')&.last

    return unless token

    begin
      decoded = AuthenticationTokenService.decode(token)

      User.includes(:roles).find(decoded[:user_id])
    rescue ActiveRecord::RecordNotFound, JWT::DecodeError, JWT::VerificationError, JWT::ExpiredSignature
      nil
    end
  end

  def render_errors(object_or_message = nil, status:)
    errors = []

    if object_or_message.respond_to?(:errors)
      errors = object_or_message.errors.full_messages
    elsif object_or_message.is_a?(String)
      errors = [object_or_message || 'An Unknown Error Occurred']
    end

    render json: { errors: }, status:
  end
end
