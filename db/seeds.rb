# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

user = User.create email: "admin@rhuidean.net"
user.password = "admin-password"
user.save!

stream = Stream.create content: { all: true }
stream.save!

thought = Thought.create content: "Abandon all hope ye who enter here", user: user
thought.save!
