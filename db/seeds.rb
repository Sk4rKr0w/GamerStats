# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
#
# PatchNote.create([

#   { title: "Patch Notes 14.12", description: "Lorem ipsum, dolor sit amet consectetur adipisicing elit. Exercitationem nemo eligendi quidem illo at fugiat debitis", game: "League of Legends",image_path: "patch_notes/lol-1.webp", link_path:"https://www.leagueoflegends.com/it-it/news/game-updates/patch-14-12-notes/"},
#   { title: "Patch Notes 14.11", description: "Lorem ipsum, dolor sit amet consectetur adipisicing elit. Exercitationem nemo eligendi quidem illo at fugiat debitis", game: "League of Legends",image_path: "patch_notes/lol-2.webp", link_path:"https://www.leagueoflegends.com/it-it/news/game-updates/patch-14-11-notes/"},
#   { title: "Patch Notes 14.10", description: "Lorem ipsum, dolor sit amet consectetur adipisicing elit. Exercitationem nemo eligendi quidem illo at fugiat debitis", game: "League of Legends",image_path: "patch_notes/lol-3.webp", link_path:"https://www.leagueoflegends.com/it-it/news/game-updates/patch-14-10-notes/"},
#   { title: "20 Giugno 2024", description: "Lorem ipsum, dolor sit amet consectetur adipisicing elit. Exercitationem nemo eligendi quidem illo at fugiat debitis", game: "Overwatch",image_path: "patch_notes/ow-1.webp", link_path:"https://overwatch.blizzard.com/en-us/news/patch-notes/"},
#   { title: "21 Febbraio 2024", description: "Lorem ipsum, dolor sit amet consectetur adipisicing elit. Exercitationem nemo eligendi quidem illo at fugiat debitis", game: "Overwatch",image_path: "patch_notes/ow-2.webp", link_path:"https://overwatch.blizzard.com/en-us/news/patch-notes/live/2024/05"},
#   { title: "28 Marzo 2024", description: "Lorem ipsum, dolor sit amet consectetur adipisicing elit. Exercitationem nemo eligendi quidem illo at fugiat debitis", game: "Overwatch",image_path: "patch_notes/ow-3.webp", link_path:"https://overwatch.blizzard.com/en-us/news/patch-notes/live/2024/04"},
#   { title: "Patch Notes 8.11", description: "Lorem ipsum, dolor sit amet consectetur adipisicing elit. Exercitationem nemo eligendi quidem illo at fugiat debitis", game: "Valorant",image_path: "patch_notes/vl-1.webp", link_path:"https://playvalorant.com/en-gb/news/game-updates/valorant-patch-notes-811/"},
#   { title: "Patch Notes 8.10", description: "Lorem ipsum, dolor sit amet consectetur adipisicing elit. Exercitationem nemo eligendi quidem illo at fugiat debitis", game: "Valorant",image_path: "patch_notes/vl-2.webp", link_path:"https://playvalorant.com/en-gb/news/game-updates/valorant-patch-notes-8-10/"},
#   { title: "Patch Notes 8.09", description: "Lorem ipsum, dolor sit amet consectetur adipisicing elit. Exercitationem nemo eligendi quidem illo at fugiat debitis", game: "Valorant",image_path: "patch_notes/vl-3.webp", link_path:"https://playvalorant.com/en-gb/news/game-updates/valorant-patch-notes-8-09/"}

# ])

#User.create(email: 'admin@example.com', password: 'Admin123!', admin: true)
