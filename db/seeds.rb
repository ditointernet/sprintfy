# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Creates users
user1 = User.create(name: 'Test User 1', email: 'user1@test.com', password: 'mypass')
user2 = User.create(name: 'Test User 2', email: 'user2@test.com', password: 'mypass')
user3 = User.create(name: 'Test User 3', email: 'user3@test.com', password: 'mypass')

# Create Squad
squad = Squad.new(name: 'Squad Test')
squad.users << user1 << user2 << user3
squad.save

# Set user1 as manager and give it admin access
SquadManager.create(user: user1, squad: squad)
user1.add_role(:admin)
user1.save

# Create Sprint
sprint = Sprint.new
sprint.squad = squad
sprint.users << user1 << user2 << user3
sprint.start_date = Date.new(2017, 1, 1)
sprint.due_date = Date.new(2017, 2, 1)
sprint.save

# Create Story Points
StoryPoint.create(sprint: sprint, user: user1, expected_value: 3.0)
StoryPoint.create(sprint: sprint, user: user2, expected_value: 7.25)
StoryPoint.create(sprint: sprint, user: user3, expected_value: 5.5)
