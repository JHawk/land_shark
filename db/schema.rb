# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150303205443) do

  create_table "actions", force: true do |t|
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "finished_at"
    t.datetime "started_at"
    t.integer  "ticks",        default: 0, null: false
    t.integer  "character_id"
  end

  add_index "actions", ["character_id"], name: "index_actions_on_character_id"

  create_table "buildings", force: true do |t|
    t.string   "name"
    t.integer  "location_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "bottom_left_x"
    t.integer  "bottom_left_y"
  end

  add_index "buildings", ["location_id"], name: "index_buildings_on_location_id"

  create_table "characters", force: true do |t|
    t.string   "name"
    t.integer  "strength"
    t.integer  "dexterity"
    t.integer  "constitution"
    t.integer  "intelligence"
    t.integer  "wisdom"
    t.integer  "charisma"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "game_id"
    t.integer  "location_id"
    t.integer  "x"
    t.integer  "y"
    t.integer  "z"
    t.integer  "land_speed"
    t.boolean  "is_pc"
    t.integer  "current_action_id"
  end

  add_index "characters", ["current_action_id"], name: "index_characters_on_current_action_id"
  add_index "characters", ["game_id"], name: "index_characters_on_game_id"

  create_table "games", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.datetime "time"
  end

  add_index "games", ["user_id"], name: "index_games_on_user_id"

  create_table "locations", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "game_id"
    t.boolean  "is_current"
    t.integer  "max_x",                default: 100, null: false
    t.integer  "max_y",                default: 100, null: false
    t.integer  "max_z",                default: 100, null: false
    t.integer  "current_character_id"
  end

  add_index "locations", ["game_id"], name: "index_locations_on_game_id"

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
