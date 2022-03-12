# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'faker'

# Creating data for the following users
usernames = ['Ivan', 'Emanuel', 'Luis', 'David', 'Peruano']
usernames.each do |username|
  # Creating Users
  User.new.tap do |usr|
    usr.email = "#{username}@email.com"
    usr.password = "password"
    usr.username = username
    usr.admin = true if username == 'Ivan'
    usr.save!
    puts "User: #{username} created"
    # Create App
    Application.new.tap do |app|
      app.name = Faker::App.name
      app.user = usr
      app.save!
      puts "-Application: #{app.name} created for user: #{username}"
      # Create list
      List.new.tap do |list|
        list.name = Faker::JapaneseMedia::DragonBall.character
        list.application = app
        list.save!
        puts "-- List: #{list.name} created"
        # Create 15 items
        i = 1
        15.times { 
          item = Item.new(list: list, content: Faker::Movies::StarWars.quote)
          item.save!
          puts "--- Item ##{i} created for List #{list.name}"
          i += 1
        }
      end
      # Create Image
      Image.new.tap do |img|
        img.title = Faker::Sports::Football.player
        img.url = Faker::Avatar.image
        img.public_id = "#{Random.new_seed}"
        img.application = app
        img.save!
        puts "-- Image: #{img.title} created"
      end
      #Create Code
      Code.new.tap do |code|
        code.title = Faker::Games::Minecraft.mob
        code.content = "<h1>This is a piece of code for #{code.title}</h1>"
        code.application = app
        code.save!
        puts "-- Code: #{code.title} created"
      end
    end
  end
end