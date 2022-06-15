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

filter = Filter.create filter_attribute: "created_at",
                       comparison_type: "interval",
                       compare_interval: 1.month

group = Group.create
group.filters << filter
group.save!

Thought.create(content: "His 5 de Mayo party starts on the 8th of March", user:)
Thought.create(content: "He played a game of Russian Roulette with a fully loaded magnum, and won", user:)
Thought.create(content: "Once while sailing around the world, he discovered a short cut", user:)
Thought.create(content: "He has inside jokes with people he’s never met.", user:)
Thought.create(content: "Bigfoot tries to get pictures of him", user:)
Thought.create(content: "The Holy Grail is looking for him", user:)
Thought.create(content: "Bigfoot tries to get pictures of him", user:)
Thought.create(content: "Once he ran a marathon because it was “on the way”", user:)
Thought.create(content: "His organ donation card also lists his beard", user:)
Thought.create(content: "He lives vicariously through himself", user:)
Thought.create(content: "Abandon all hope ye who enter here", user:)
