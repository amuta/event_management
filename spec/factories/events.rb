FactoryBot.define do
  factory :event do
    sequence(:name) { |n| "Sample Event #{n}" }
    description { "This is a sample event." }
    location { "Sample Location" }
    start_time { DateTime.now }
    end_time { DateTime.now + 1.hour }
    association :user
  end
end
