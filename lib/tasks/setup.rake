namespace :setup do
  desc 'Generate a sample secret_key for development if not present'
  task generate_secret_key: :environment do
    if Rails.env.development? && !Rails.application.credentials[:secret_key_base]

      puts 'No secret_key_base found in credentials. Generating a sample secret_key_base for development...'

      # Ensure credentials.yml.enc is set up
      system('EDITOR=cat rails credentials:edit') unless Rails.application.credentials.configured?

      puts 'Sample secret_key_base added to credentials.yml.enc'
    end
  end
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
