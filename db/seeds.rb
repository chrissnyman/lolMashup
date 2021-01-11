# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

GameMode.delete_all
GameMode.create({name: 'No Rules'})
GameMode.create({name: 'Classic 5v5', min_players: 5})
GameMode.create({name: 'Classic 5v5 (No Jungle)', min_players: 5})
GameMode.create({name: 'Custom', min_players: 2})
GameMode.create({name: 'Custom (No Jungle)', min_players: 2})
GameMode.create({name: 'Mirrored 5v5', min_players: 10})
GameMode.create({name: 'Mirrored (No Jungle)', min_players: 2, even_player_count_needed: true})

LaneRole.delete_all
LaneRole.create({name: 'Top'})
LaneRole.create({name: 'Mid'})
LaneRole.create({name: 'Jungle'})
LaneRole.create({name: 'Bottom'})
LaneRole.create({name: 'Support'})
