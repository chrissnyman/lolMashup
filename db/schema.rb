# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_01_09_034159) do

  create_table "champions", force: :cascade do |t|
    t.string "name"
    t.string "imagename"
    t.string "image"
    t.string "info"
    t.string "partype"
    t.string "tags"
    t.string "title"
    t.string "stats"
  end

  create_table "match_groups", force: :cascade do |t|
    t.string "uuid"
    t.string "name"
    t.string "region"
    t.string "password"
    t.string "mode"
    t.integer "size"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "roll_results", force: :cascade do |t|
    t.integer "summoner_match_group_id"
    t.integer "champion_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
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
    t.datetime "last_play_time"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "summoner_match_groups", force: :cascade do |t|
    t.integer "summoner_id"
    t.integer "match_group_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "summoners", force: :cascade do |t|
    t.string "name"
    t.string "profile_icon_id"
    t.string "summoner_level"
    t.string "region"
    t.string "riot_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
