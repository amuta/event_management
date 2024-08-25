class AuthenticationTokenService
  class UserTokenError < StandardError; end

  SECRET_KEY = Rails.application.credentials.dig(:secret_key_base).to_s
  DEFAULT_EXPIRATION_TIME = 3.days

  def self.encode(user_id, exp = DEFAULT_EXPIRATION_TIME.from_now)
    payload = { user_id:, exp: exp.to_i }
    JWT.encode(payload, SECRET_KEY)
  end

  def self.decode(token)
    raise JWT::DecodeError unless token

    decoded = JWT.decode(token, SECRET_KEY).first
    HashWithIndifferentAccess.new(decoded)
  rescue JWT::ExpiredSignature, JWT::VerificationError, JWT::DecodeError => e
    raise UserTokenError, e.message
  end
end
