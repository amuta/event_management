class Role < ApplicationRecord
  serialize :permissions, coder: YAML, class_name: Array
  validates :name, presence: true, uniqueness: true
  validate :cant_modify_admin_role

  has_and_belongs_to_many :users

  def permits?(behavior)
    return true if admin?

    permissions.include?(behavior)
  end

  def self.admin
    Role.find_by(name: 'admin')
  end

  private

  def admin?
    name == 'admin'
  end

  def cant_modify_admin_role
    return if name != 'admin' && name_was != 'admin'

    errors.add(:base, 'Cannot modify admin role')
  end
end
