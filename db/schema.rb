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

ActiveRecord::Schema.define(version: 20140118030857) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "chat_messages", force: true do |t|
    t.integer  "room_id"
    t.integer  "user_id"
    t.string   "body"
    t.string   "public_body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "items", force: true do |t|
    t.integer "room_id"
    t.integer "user_id"
    t.integer "row"
    t.integer "col"
    t.string  "slug"
  end

  create_table "memories", force: true do |t|
    t.integer "user_id"
    t.integer "room_id"
    t.text    "fixtures"
  end

  create_table "monsters", force: true do |t|
    t.integer "room_id"
    t.integer "row"
    t.integer "col"
    t.integer "health"
    t.string  "slug"
    t.integer "target_id"
  end

  create_table "portals", force: true do |t|
    t.integer "entry_room_id"
    t.integer "entry_row"
    t.integer "entry_col"
    t.string  "char"
    t.integer "exit_room_id"
    t.integer "exit_row"
    t.integer "exit_col"
  end

  create_table "rooms", force: true do |t|
    t.text "fixtures"
  end

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
    t.integer  "col",                    default: 1
    t.integer  "row",                    default: 1
    t.integer  "room_id"
    t.integer  "health",                 default: 14
    t.integer  "max_health",             default: 14
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "items", "rooms", name: "items_room_id_fk"
  add_foreign_key "items", "users", name: "items_user_id_fk"

  add_foreign_key "memories", "users", name: "memories_user_id_fk"

  add_foreign_key "monsters", "rooms", name: "monsters_room_id_fk"

  add_foreign_key "users", "rooms", name: "users_room_id_fk"

end
