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
require "open-uri"
require "json"

james_bond_titles = [
  "Dr. No",
  "Goldfinger",
  "You Only Live Twice",
  "The Spy Who Loved Me",
  "GoldenEye",
  "Casino Royale",
  "Skyfall",
  "Spectre",
  "No Time to Die"
]

james_bond_titles.each do |title|
  url = "https://tmdb.lewagon.com/search/movie?query=#{URI.encode_www_form_component(title)}"
  response = URI.open(url).read
  data = JSON.parse(response)
  movie_data = data["results"].first

  next if movie_data.nil?

  Movie.find_or_create_by!(title: movie_data["title"]) do |m|
    m.overview = movie_data["overview"]
    m.poster_url = "https://image.tmdb.org/t/p/original#{movie_data["poster_path"]}"
    m.rating = movie_data["vote_average"]
  end
end

puts "Seeded #{Movie.count} movies!"
