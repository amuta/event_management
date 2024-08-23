class User < ApplicationRecord
  has_secure_password

  # Validations
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password_digest, presence: true

  # Associations
  has_many :events, dependent: :destroy
end
