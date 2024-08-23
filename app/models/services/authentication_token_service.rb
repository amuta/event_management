class AuthenticationTokenService
  SECRET_KEY = Rails.application.secrets.secret_key_base.to_s

  def self.encode(user_id)
    JWT.encode({ user_id: user_id }, SECRET_KEY)
  end

  def self.decode(token)
    raise JWT::DecodeError unless token

    decoded = JWT.decode(token, SECRET_KEY).first
    HashWithIndifferentAccess.new(decoded)
  end
end
