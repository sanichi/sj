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

ActiveRecord::Schema[8.1].define(version: 2022_03_30_163338) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "games", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.boolean "debug", default: false
    t.boolean "four", default: false
    t.integer "hand", limit: 2, default: 1
    t.integer "m1", limit: 2, default: 10
    t.integer "m2", limit: 2, default: 5
    t.integer "p0", limit: 2, default: 15
    t.integer "p1", limit: 2, default: 10
    t.integer "p10", limit: 2, default: 10
    t.integer "p11", limit: 2, default: 10
    t.integer "p12", limit: 2, default: 10
    t.integer "p2", limit: 2, default: 10
    t.integer "p3", limit: 2, default: 10
    t.integer "p4", limit: 2, default: 10
    t.integer "p5", limit: 2, default: 10
    t.integer "p6", limit: 2, default: 10
    t.integer "p7", limit: 2, default: 10
    t.integer "p8", limit: 2, default: 10
    t.integer "p9", limit: 2, default: 10
    t.integer "participants", limit: 2, default: 2
    t.boolean "shuffle", default: true
    t.string "state", limit: 10, default: "waiting"
    t.datetime "updated_at", null: false
    t.integer "upto", limit: 2, default: 100
    t.bigint "user_id"
    t.integer "votes", limit: 2, default: 0
    t.index ["user_id"], name: "index_games_on_user_id"
  end

  create_table "messages", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "game_id"
    t.string "json"
    t.boolean "only_start", default: false
    t.bigint "target", default: 0
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_messages_on_game_id"
  end

  create_table "players", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.boolean "dealt", default: false
    t.bigint "game_id"
    t.integer "place", limit: 2, default: 0
    t.integer "pscore", limit: 2, default: 0
    t.integer "score", limit: 2, default: 0
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["game_id"], name: "index_players_on_game_id"
    t.index ["user_id"], name: "index_players_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.boolean "admin", default: false
    t.datetime "created_at", null: false
    t.string "first_name", limit: 15
    t.string "handle", limit: 10
    t.string "last_name", limit: 15
    t.string "password_digest"
    t.datetime "updated_at", null: false
  end
end
