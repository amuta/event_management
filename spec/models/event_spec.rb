require 'rails_helper'

RSpec.describe Event, type: :model do
  subject { create(:event) }

  describe 'Associations' do
    it { should belong_to(:user) }
  end

  describe 'Validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:location) }
    it { should validate_presence_of(:start_time) }
    it { should validate_presence_of(:end_time) }

    it 'validates that end_time is after start_time' do
      subject.start_time = Time.now
      subject.end_time = subject.start_time - 1.hour
      expect(subject).not_to be_valid
      expect(subject.errors[:end_time]).to include('must be after the start time')
    end
  end

  describe '#as_json' do
    it 'returns the expected JSON representation of the event' do
      expected_json = {
        'id' => subject.id,
        'name' => subject.name,
        'description' => subject.description,
        'location' => subject.location,
        'start_time' => subject.start_time.rfc3339,
        'end_time' => subject.end_time.rfc3339,
        'user_id' => subject.user_id
      }
      expect(subject.as_json).to eq(expected_json)
    end
  end
end
