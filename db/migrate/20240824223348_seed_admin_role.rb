class SeedAdminRole < ActiveRecord::Migration[7.0]
  def up
    admin_role = Role.new(
      name: 'admin',
      permissions: []
    )

    admin_role.save(validate: false)
  end

  def down
    Role.find_by(name: 'admin')&.destroy
  end
end
