namespace :setup do
  desc 'Generate a sample secret_key for development if not present'
  task generate_secret_key: :environment do
    if Rails.env.development? && !Rails.application.credentials[:jwt]
      puts 'No JWT secret_key found in credentials. Generating a sample secret_key for development...'

      # Ensure credentials.yml.enc is set up
      system('EDITOR=cat rails credentials:edit') unless Rails.application.credentials.configured?

      # Open credentials and add a sample secret_key
      key = SecureRandom.hex(64)
      system("EDITOR=\"sed -i'' -e '$a\\jwt:\\n  secret_key: #{key}\\n'\" rails credentials:edit")

      puts "Sample secret_key added to credentials.yml.enc: #{key}"
    else
      puts 'JWT secret_key already exists or not in development environment.'
    end
  end
end
