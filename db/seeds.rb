# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


25.times do
  User.create!(
      username: Faker::Internet.user_name,
      email:  Faker::Internet.email,
      password: Faker::Internet.password,
      confirmed_at: Faker::Time.between(10.days.ago, Date.today, :all)
  )
end

25.times do
  Wiki.create!(
          title: Faker::Hacker.say_something_smart,
          body: Faker::Lorem.paragraph,
          private: false,
          user_id: Faker::Number.between(1, 25)
  )
end
