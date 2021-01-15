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

StatMod.create({name: 'Adaptive Force', icon: 'perk-images/StatMods/StatModsAdaptiveForceIcon.png', allowed_in_slot: "1,2"})
StatMod.create({name: 'Armor', icon: 'perk-images/StatMods/StatModsArmorIcon.png', allowed_in_slot: "2,3"})
StatMod.create({name: 'Attack Speed', icon: 'perk-images/StatMods/StatModsAttackSpeedIcon.png', allowed_in_slot: "1"})
StatMod.create({name: 'CDR Scaling', icon: 'perk-images/StatMods/StatModsCDRScalingIcon.png', allowed_in_slot: "1"})
StatMod.create({name: 'Health Scaling', icon: 'perk-images/StatMods/StatModsHealthScalingIcon.png', allowed_in_slot: "3"})
StatMod.create({name: 'Magic Resist', icon: 'perk-images/StatMods/StatModsMagicResIcon.png', allowed_in_slot: "2,3"})

WinCondition.create({title: 'Total Units Healed',                         description: 'Total Units Healed',                     condition_metric: 'totalUnitsHealed',                   metric_calc_type: 'desc'})
WinCondition.create({title: 'Largest MultiKill',                          description: 'Largest MultiKill',                      condition_metric: 'largestMultiKill',                   metric_calc_type: 'desc'})
WinCondition.create({title: 'Gold Earned',                                description: 'Gold Earned',                            condition_metric: 'goldEarned',                         metric_calc_type: 'desc'})
WinCondition.create({title: 'Total PlayerScore',                          description: 'Total PlayerScore',                      condition_metric: 'totalPlayerScore',                   metric_calc_type: 'desc'})
WinCondition.create({title: 'First ToLevel 18',                           description: 'First ToLevel 18',                       condition_metric: 'playerLevel',                        metric_calc_type: 'desc'})
WinCondition.create({title: 'Damage Dealt To Objectives',                 description: 'Damage Dealt To Objectives',             condition_metric: 'damageDealtToObjectives',            metric_calc_type: 'desc'})
WinCondition.create({title: 'Most Total Damage Taken',                    description: 'Most Total Damage Taken',                condition_metric: 'totalDamageTaken',                   metric_calc_type: 'desc'})
WinCondition.create({title: 'Least Total Damage Taken',                   description: 'Least Total Damage Taken',               condition_metric: 'totalDamageTaken',                   metric_calc_type: 'asc'})
WinCondition.create({title: 'Neutral Minions Killed',                     description: 'Neutral Minions Killed',                 condition_metric: 'neutralMinionsKilled',               metric_calc_type: 'desc'})
WinCondition.create({title: 'Least Deaths',                               description: 'Least Deaths',                           condition_metric: 'deaths',                             metric_calc_type: 'asc'})
WinCondition.create({title: 'Triple Kills',                               description: 'Triple Kills',                           condition_metric: 'tripleKills',                        metric_calc_type: 'desc'})
WinCondition.create({title: 'Wards Killed',                               description: 'Wards Killed',                           condition_metric: 'wardsKilled',                        metric_calc_type: 'desc'})
WinCondition.create({title: 'Penta Kills',                                description: 'Penta Kills',                            condition_metric: 'pentaKills',                         metric_calc_type: 'desc'})
WinCondition.create({title: 'Damage Self Mitigated',                      description: 'Damage Self Mitigated',                  condition_metric: 'damageSelfMitigated',                metric_calc_type: 'desc'})
WinCondition.create({title: 'Total Score Rank',                           description: 'Total Score Rank',                       condition_metric: 'totalScoreRank',                     metric_calc_type: 'desc'})
WinCondition.create({title: 'Wards Placed',                               description: 'Wards Placed',                           condition_metric: 'wardsPlaced',                        metric_calc_type: 'desc'})
WinCondition.create({title: 'Total Damage Dealt',                         description: 'Total Damage Dealt',                     condition_metric: 'totalDamageDealt',                   metric_calc_type: 'desc'})
WinCondition.create({title: 'Time CCing Others',                          description: 'Time CCing Others',                      condition_metric: 'timeCCingOthers',                    metric_calc_type: 'desc'})
WinCondition.create({title: 'Largest Killing Spree',                      description: 'Largest Killing Spree',                  condition_metric: 'largestKillingSpree',                metric_calc_type: 'desc'})
WinCondition.create({title: 'Total Damage Dealt To Champions',            description: 'Total Damage Dealt To Champions',        condition_metric: 'totalDamageDealtToChampions',        metric_calc_type: 'desc'})
WinCondition.create({title: 'Neutral Minions Killed Team Jungle',         description: 'Neutral Minions Killed Team Jungle',     condition_metric: 'neutralMinionsKilledTeamJungle',     metric_calc_type: 'desc'})
WinCondition.create({title: 'Total Minions Killed',                       description: 'Total Minions Killed',                   condition_metric: 'totalMinionsKilled',                 metric_calc_type: 'desc'})
WinCondition.create({title: 'Objective Player Score',                     description: 'Objective Player Score',                 condition_metric: 'objectivePlayerScore',               metric_calc_type: 'desc'})
WinCondition.create({title: 'Kills',                                      description: 'Kills',                                  condition_metric: 'kills',                              metric_calc_type: 'desc'})
WinCondition.create({title: 'Combat Player Score',                        description: 'Combat Player Score',                    condition_metric: 'combatPlayerScore',                  metric_calc_type: 'desc'})
WinCondition.create({title: 'Inhibitor Kills',                            description: 'Inhibitor Kills',                        condition_metric: 'inhibitorKills',                     metric_calc_type: 'desc'})
WinCondition.create({title: 'Turret Kills',                               description: 'Turret Kills',                           condition_metric: 'turretKills',                        metric_calc_type: 'desc'})
WinCondition.create({title: 'Assists',                                    description: 'Assists',                                condition_metric: 'assists',                            metric_calc_type: 'desc'})
WinCondition.create({title: 'Team Objective',                             description: 'Team Objective',                         condition_metric: 'teamObjective',                      metric_calc_type: 'desc'})
WinCondition.create({title: 'Gold Spent',                                 description: 'Gold Spent',                             condition_metric: 'goldSpent',                          metric_calc_type: 'desc'})
WinCondition.create({title: 'Damage Dealt To Turrets',                    description: 'Damage Dealt To Turrets',                condition_metric: 'damageDealtToTurrets',               metric_calc_type: 'desc'})
WinCondition.create({title: 'Total Heal',                                 description: 'Total Heal',                             condition_metric: 'totalHeal',                          metric_calc_type: 'desc'})
WinCondition.create({title: 'Unreal Kills',                               description: 'Unreal Kills',                           condition_metric: 'unrealKills',                        metric_calc_type: 'desc'})
WinCondition.create({title: 'Vision Score',                               description: 'Vision Score',                           condition_metric: 'visionScore',                        metric_calc_type: 'desc'})
WinCondition.create({title: 'Physical DamageDealt',                       description: 'Physical DamageDealt',                   condition_metric: 'physicalDamageDealt',                metric_calc_type: 'desc'})
WinCondition.create({title: 'Longest Time Spent Living',                  description: 'Longest Time Spent Living',              condition_metric: 'longestTimeSpentLiving',             metric_calc_type: 'desc'})
WinCondition.create({title: 'Killing Sprees',                             description: 'Killing Sprees',                         condition_metric: 'killingSprees',                      metric_calc_type: 'desc'})
WinCondition.create({title: 'Sight Wards Bought InGame',                  description: 'Sight Wards Bought InGame',              condition_metric: 'sightWardsBoughtInGame',             metric_calc_type: 'desc'})
WinCondition.create({title: 'Neutral Minions Killed Enemy Jungle',        description: 'Neutral Minions Killed Enemy Jungle',    condition_metric: 'neutralMinionsKilledEnemyJungle',    metric_calc_type: 'desc'})
WinCondition.create({title: 'Double Kills',                               description: 'Double Kills',                           condition_metric: 'doubleKills',                        metric_calc_type: 'desc'})
WinCondition.create({title: 'Quadra Kills',                               description: 'Quadra Kills',                           condition_metric: 'quadraKills',                        metric_calc_type: 'desc'})