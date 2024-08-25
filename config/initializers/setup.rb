Rake::Task['setup:generate_secret_key'].invoke if Rails.env.development?
