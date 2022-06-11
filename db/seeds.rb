# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

user = User.create email: "admin@groupthink.me"
user.password = "admin-password"
user.save!

group = Group.create created_ago: 1.month
group.save!

thought = Thought.create content: "Abandon all hope ye who enter here", user: user
thought.save!
