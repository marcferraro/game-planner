# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'httparty'

url = "https://api.boardgameatlas.com/api/search?order_by=popularity&ascending=false&pretty=true&client_id=ewGvicQBqR"
# byebug
response = HTTParty.get(url)



User.destroy_all
Community.destroy_all
Game.destroy_all
Session.destroy_all
UserCommunity.destroy_all
UserSession.destroy_all

15.times do
    User.create(
        name: Faker::Name.name, 
        username: Faker::Internet.username, 
        password: Faker::Internet.password, 
        email: Faker::Internet.safe_email,
        age: Faker::Number.within(range: 8..16)
    )
end

count = 0

20.times do

    average_playtime = (response["games"][count]["min_playtime"].to_f + response["games"][count]["max_playtime"].to_f) / 2

    Game.create(
        title: response["games"][count]["name"],
        min_players: response["games"][count]["min_players"],
        max_players: response["games"][count]["max_players"],
        price: response["games"][count]["msrp"],
        min_age: response["games"][count]["min_age"],
        #parse description here
        description: response["games"][count]["description"],
        avg_playtime: average_playtime,
        rules: response["games"][count]["rules_url"]
    )
    count +=1
end

30.times do

    bool = [true, false]

    community_type = [Game.all.sample.title, "Board Game", "TTRPG", "Party Game"]

    Community.create(
        title:  "#{community_type.sample} Community",
        bio: "We are a community of fans who love to play #{Game.all.sample.title}.",
        public: bool.sample
    )
end

50.times do
    game = Game.all.sample
    Session.create(
        date: Faker::Date.forward(days: 30),
        game_id: game.id
    )
end

60.times do
    community = Community.all.sample
    user = User.all.sample
    UserCommunity.find_or_create_by(
        user_id: user.id,
        community_id: community.id
    )
end

80.times do
    user = User.all.sample
    session = Session.all.sample
    UserSession.find_or_create_by(
        user_id: user.id,
        session_id: session.id
    )
end

puts "#{User.all.count} users"
puts "#{Game.all.count} games"
puts "#{Community.all.count} communities"
puts "#{Session.all.count} sessions"
puts "#{UserCommunity.all.count} user_communities"
puts "#{UserSession.all.count} user_sessions"