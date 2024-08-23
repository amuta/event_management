class User < ApplicationRecord
  has_secure_password

  # Validations
  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password_digest, presence: true

  # Associations
  has_many :events, dependent: :destroy

  # Callbacks
  before_save :downcase_email

  def auth_token
    AuthenticationTokenService.encode(self.id)
  end

  private

  def downcase_email
    self.email = email.downcase if email.present?
  end

end