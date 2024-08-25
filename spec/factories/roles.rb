FactoryBot.define do
  factory :role do
    sequence(:name) { |n| "Role #{n}" }
    permissions { ['__some_permission__'] }
  end
  factory :admin_role do
    name { "admin" }
    permissions { [] }
  end
  factory :event_manager_role do
    name { "event_manager" }
    permissions { ['__modify_any_event__'] }
  end
end
