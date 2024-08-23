class Event < ApplicationRecord
  # Associations
  belongs_to :user

  # Validations
  validates :name, presence: true
  validates :location, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validate :end_time_after_start_time

  private

  def end_time_after_start_time
    if end_time < start_time
      errors.add(:end_time, "must be after the start time")
    end
  end
end
