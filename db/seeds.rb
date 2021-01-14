# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

LaneRole.create({name: 'Top'})
LaneRole.create({name: 'Jungle'})
LaneRole.create({name: 'Mid'})
LaneRole.create({name: 'Bottom'})
LaneRole.create({name: 'Support'})

ServerRegion.create(region_code:"EUN1", name: "EUN")
ServerRegion.create(region_code:"EUW1", name: "EUW")
ServerRegion.create(region_code:"JP1", name: "JP")
ServerRegion.create(region_code:"KR", name: "KR")
ServerRegion.create(region_code:"LA1", name: "LA1")
ServerRegion.create(region_code:"LA2", name: "LA2")
ServerRegion.create(region_code:"NA1", name: "NA")
ServerRegion.create(region_code:"OC1", name: "OC")
ServerRegion.create(region_code:"TR1", name: "TR")
ServerRegion.create(region_code:"RU", name: "RU")

Rule.create({name: 'player_count_5v5', check_val: 'player_count', check_calc: 'eq_or:5:10', required: true})
Rule.create({name: 'player_count_min_2', check_val: 'player_count', check_calc: 'min:2', required: true})
Rule.create({name: 'player_count_even', check_val: 'player_count', check_calc: 'mod:2:0', required: true})

GameMode.create({name: 'No Rules'})
GameMode.create({name: 'Classic 5v5', rules: [
    Rule.where(name:'player_count_5v5').first,
]}) 
GameMode.create({name: 'Classic 5v5 (No Jungle)', rules:[
    Rule.where(name:'player_count_5v5').first,
]})
GameMode.create({name: 'Custom', rules:[
    Rule.where(name:'player_count_min_2').first,
]})
GameMode.create({name: 'Custom (No Jungle)', rules:[
    Rule.where(name:'player_count_min_2').first,
]})
GameMode.create({name: 'Mirrored', rules:[
    Rule.where(name:'player_count_even').first,
]})
GameMode.create({name: 'Mirrored (No Jungle)', rules:[
    Rule.where(name:'player_count_even').first,
]})
