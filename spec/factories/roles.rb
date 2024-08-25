FactoryBot.define do
  factory :role do
    sequence(:name) { |n| "Role #{n}" }
    permissions { ['__some_permission__'] }

    trait :admin do
      name { 'admin' }
      permissions do
        %w[
          __update_any_event__
          __delete_any_event__
          __add_user_role__
          __remove_user_role__
          __index_roles__
          __index_users__
          __index_user_roles__
        ]
      end
    end

    trait :event_manager do
      name { 'event_manager' }
      permissions do
        %w[
          __update_any_event__
          __delete_any_event__
        ]
      end
    end

    trait :user_manager do
      name { 'user_manager' }
      permissions do
        %w[
          __add_user_role__
          __remove_user_role__
          __index_roles__
          __index_users__
          __index_user_roles__
        ]
      end
    end
  end
end
