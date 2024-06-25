# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
PatchNote.create([

  { title: "Patch Notes 14.12", description: "Lorem ipsum, dolor sit amet consectetur adipisicing elit. Exercitationem nemo eligendi quidem illo at fugiat debitis", game: "League of Legends",image_path: "lol-1.jpg" },
  { title: "Patch Notes 14.11", description: "Lorem ipsum, dolor sit amet consectetur adipisicing elit. Exercitationem nemo eligendi quidem illo at fugiat debitis", game: "League of Legends",image_path: "lol-2.jpg" },
  { title: "Patch Notes 14.10", description: "Lorem ipsum, dolor sit amet consectetur adipisicing elit. Exercitationem nemo eligendi quidem illo at fugiat debitis", game: "League of Legends",image_path: "lol-3.jpg" },
  { title: "20 Giugno 2024", description: "Lorem ipsum, dolor sit amet consectetur adipisicing elit. Exercitationem nemo eligendi quidem illo at fugiat debitis", game: "Overwatch",image_path: "ow-1.jpg" },
  { title: "21 Febbraio 2024", description: "Lorem ipsum, dolor sit amet consectetur adipisicing elit. Exercitationem nemo eligendi quidem illo at fugiat debitis", game: "Overwatch",image_path: "ow-2.jpg" },
  { title: "28 Marzo 2024", description: "Lorem ipsum, dolor sit amet consectetur adipisicing elit. Exercitationem nemo eligendi quidem illo at fugiat debitis", game: "Overwatch",image_path: "ow-3.jpg" },
  { title: "Patch Notes 8.11", description: "Lorem ipsum, dolor sit amet consectetur adipisicing elit. Exercitationem nemo eligendi quidem illo at fugiat debitis", game: "Valorant",image_path: "vl-1.jpg" },
  { title: "Patch Notes 8.10", description: "Lorem ipsum, dolor sit amet consectetur adipisicing elit. Exercitationem nemo eligendi quidem illo at fugiat debitis", game: "Valorant",image_path: "vl-2.jpg" },
  { title: "Patch Notes 8.09", description: "Lorem ipsum, dolor sit amet consectetur adipisicing elit. Exercitationem nemo eligendi quidem illo at fugiat debitis", game: "Valorant",image_path: "vl-3.jpg" }

])
