class SeedEventManagerRole < ActiveRecord::Migration[7.1]
  def change
    Role.find_or_create_by!(name: 'event_manager', permissions: ['__modify_any_event__'])
  end

  def down
    Role.find_by(name: 'event_manager')&.destroy
  end
end
