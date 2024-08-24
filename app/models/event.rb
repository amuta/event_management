class Event < ApplicationRecord
  # Associations
  belongs_to :user

  # Validations
  validates :name, presence: true
  validates :location, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validate :end_time_after_start_time

  def as_json
    {
      id: id,
      name: name,
      description: description,
      location: location,
      start_time: start_time.strftime("%Y-%m-%d %H:%M:%S"),
      end_time: end_time.strftime("%Y-%m-%d %H:%M:%S"),
      user_id: user_id
    }
  end

  private

  def end_time_after_start_time
    if end_time < start_time
      errors.add(:end_time, "must be after the start time")
    end
  end
end
