class AdminCreatorService
  class AdminRoleNotFound < StandardError; end
  class UserCreationError < StandardError; end

  def self.call(email:, password:)
    user = find_or_create_user(email:, password:)
    assign_admin_role(user)
  end

  def self.find_or_create_user(email:, password:)
    User.find_or_initialize_by(email:) do |u|
      u.name = 'Admin User'
      u.password = password
      u.password_confirmation = password
    end.tap do |user|
      raise UserCreationError, "Failed to create/update user: #{user.errors.full_messages.join(', ')}" unless user.save
    end
  end

  def self.assign_admin_role(user)
    admin_role = Role.find_by(name: 'admin')
    raise AdminRoleNotFound, 'Make sure to run `rake roles:seed` first.' unless admin_role

    return if user.roles.include?(admin_role)

    user.roles << admin_role
    puts "User '#{user.email}' has been created/updated with the admin role."
  end
end
