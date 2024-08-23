FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "John Doe #{n}" }
    sequence(:email) { |n| "johndoe#{n}@example.com" }
    password { "password" }
    password_confirmation { "password" }

    trait :with_events do
      transient do
        events_count { 5 }
      end

      after(:create) do |user, evaluator|
        create_list(:event, evaluator.events_count, user: user)
      end
    end
  end
end
