# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

10.times do
  Task.create(
    comment: Faker::Lorem.sentence,
    time_type: 'montly',
    start_time: Faker::Time.between(from: DateTime.now - 14, to: DateTime.now - 7),
    end_time: Faker::Time.between(from: DateTime.now - 7, to: DateTime.now)
  )
end
