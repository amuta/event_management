# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# db/seeds.rb

require 'faker'

# Clear existing data
Event.destroy_all
User.destroy_all

# Create users
users = []
10.times do |i|
  users << User.create!(
    name: Faker::Name.name,
    email: "user#{i+1}@example.com",
    password: 'password'
  )
end

# Create events for each user
users.each do |user|
  12.times do
    Event.create!(
      name: Faker::Lorem.sentence,
      description: Faker::Lorem.paragraph,
      location: Faker::Address.full_address,
      start_time: 1.week.from_now,
      end_time: 2.weeks.from_now + 2.hours,
      user: user
    )
  end
end

puts "Created #{User.count} users"
puts "Created #{Event.count} events"
