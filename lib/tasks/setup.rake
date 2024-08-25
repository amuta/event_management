namespace :setup do
  desc 'Generate a sample secret_key for development if not present'
  task seed_roles: :environment do
    RoleSeederService.seed_roles
  end

  desc 'Create a user with the admin role'
  task create_admin_user: :environment do
    email = ENV['EMAIL']
    password = ENV['PASSWORD']

    unless email && password
      puts 'Please provide email and password. Example: rake setup:create_admin_user EMAIL=myadmin@email.com PASSWORD=password'
      exit 1
    end

    AdminCreatorService.call(email:, password:)
  end
end
