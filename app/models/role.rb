# frozen_string_literal: true

class Role < ApplicationRecord
  serialize :permissions, coder: YAML, class_name: Array
  validates :name, presence: true, uniqueness: true

  has_and_belongs_to_many :users

  def permits?(behavior)
    permissions.include?(behavior)
  end
end
