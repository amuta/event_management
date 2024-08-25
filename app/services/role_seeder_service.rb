# frozen_string_literal: true

module RoleSeederService
  class RoleSeedingError < StandardError; end

  DEFAULT_ROLES = [
    {
      name: 'admin',
      permissions: %w[
        __update_any_event__
        __delete_any_event__
        __add_user_role__
        __remove_user_role__
        __index_roles__
        __index_users__
        __index_user_roles__
      ]
    },
    {
      name: 'event_manager',
      permissions: %w[
        __update_any_event__
        __delete_any_event__
      ]
    },
    {
      name: 'user_manager',
      permissions: %w[
        __add_user_role__
        __remove_user_role__
        __index_roles__
        __index_users__
        __index_user_roles__
      ]
    }
  ].freeze

  def self.seed_roles
    DEFAULT_ROLES.each do |role_data|
      seed_role(role_data)
    end
  end

  def self.seed_role(role_data)
    role = Role.find_or_initialize_by(name: role_data[:name])
    role.permissions = role_data[:permissions]

    unless role.save(validate: false)
      raise RoleSeedingError,
            "Failed to create/update role '#{role.name}': #{role.errors.full_messages.join(', ')}"
    end

    puts "Role '#{role.name}' has been created/updated."
  end
end
