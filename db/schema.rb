# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2021_01_15_210153) do
  create_table "champion_spells", force: :cascade do |t|
    t.integer "champion_id"
    t.string "spell_id"
    t.string "name"
    t.string "imagename"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "button_binding"
  end

  create_table "champions", force: :cascade do |t|
    t.string "champion_id"
    t.string "name"
    t.string "imagename"
    t.string "image"
    t.string "info"
    t.string "partype"
    t.string "tags"
    t.string "title"
    t.string "stats"
  end

  create_table "game_modes", force: :cascade do |t|
    t.string "name"
    t.integer "min_players", default: 1
    t.boolean "even_player_count_needed", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "game_modes_rules", id: false, force: :cascade do |t|
    t.integer "game_mode_id", null: false
    t.integer "rule_id", null: false
  end

  create_table "items", force: :cascade do |t|
    t.string "name"
    t.string "imagename"
    t.string "rarity"
    t.integer "depth"
    t.string "image"
    t.string "tags"
    t.string "into"
    t.string "from"
    t.string "maps"
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "purchasable"
    t.integer "gold"
  end

  create_table "lane_roles", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "match_groups", force: :cascade do |t|
    t.string "uuid"
    t.string "name"
    t.string "region"
    t.string "password"
    t.integer "size"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "game_mode_id"
    t.string "team1_name", default: "Blue Team"
    t.string "team2_name", default: "Red Team"
    t.integer "win_condition_id"
  end

  create_table "roll_results", force: :cascade do |t|
    t.integer "champion_id"
    t.integer "champion_spell_id"
    t.string "item_build"
    t.string "rune_build"
    t.string "summoner_spells"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "lane_role_id"
  end

  create_table "rules", force: :cascade do |t|
    t.string "name"
    t.string "check_val"
    t.string "check_calc"
    t.boolean "required"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rune_slots", force: :cascade do |t|
    t.integer "rune_tree_id"
    t.integer "slot_index"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rune_trees", force: :cascade do |t|
    t.string "icon"
    t.string "key"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "runes", force: :cascade do |t|
    t.integer "rune_slot_id"
    t.string "icon"
    t.string "key"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "server_regions", force: :cascade do |t|
    t.string "name"
    t.string "region_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "free_champion_ids"
  end

  create_table "stat_mods", force: :cascade do |t|
    t.string "name"
    t.string "icon"
    t.string "allowed_in_slot"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "summoner_champions", force: :cascade do |t|
    t.integer "summoner_id"
    t.integer "champion_id"
    t.integer "mastery_level"
    t.integer "champion_points"
    t.integer "champion_points_since_last"
    t.integer "champion_points_to_next"
    t.string "chest_granted"
    t.string "tokens_earned"
    t.datetime "last_play_time", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "summoner_match_groups", force: :cascade do |t|
    t.integer "summoner_id"
    t.integer "match_group_id"
    t.integer "lane_role_id"
    t.integer "team"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "roll_result_id"
  end

  create_table "summoner_spells", force: :cascade do |t|
    t.string "spell_id"
    t.string "name"
    t.string "imagename"
    t.string "modes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "summoners", force: :cascade do |t|
    t.string "name"
    t.string "profile_icon_id"
    t.string "summoner_level"
    t.string "region"
    t.string "riot_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "riot_account_id"
  end

  create_table "win_conditions", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.string "condition_metric"
    t.string "metric_calc_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
