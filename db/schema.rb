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

ActiveRecord::Schema.define(version: 20170507180224) do

  create_table "emails", force: :cascade do |t|
    t.text     "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "events", force: :cascade do |t|
    t.string   "title"
    t.string   "description"
    t.string   "location"
    t.datetime "startdate"
    t.datetime "enddate"
    t.text     "link"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.integer  "user_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.index ["user_id", "created_at"], name: "index_events_on_user_id_and_created_at"
    t.index ["user_id"], name: "index_events_on_user_id"
  end

  create_table "lostandfounds", force: :cascade do |t|
    t.string   "title"
    t.string   "item"
    t.string   "foundlocation"
    t.datetime "foundtime"
    t.text     "notes"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.integer  "user_id"
    t.string   "lostorfound"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.index ["user_id", "created_at"], name: "index_lostandfounds_on_user_id_and_created_at"
    t.index ["user_id"], name: "index_lostandfounds_on_user_id"
  end

  create_table "rides", force: :cascade do |t|
    t.string   "title"
    t.string   "origin"
    t.string   "destination"
    t.integer  "seats"
    t.datetime "time"
    t.string   "role"
    t.text     "notes"
    t.integer  "user_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["user_id", "created_at"], name: "index_rides_on_user_id_and_created_at"
    t.index ["user_id"], name: "index_rides_on_user_id"
  end

  create_table "saves", force: :cascade do |t|
    t.string   "saveable_type"
    t.integer  "saveable_id"
    t.string   "saver_type"
    t.integer  "saver_id"
    t.boolean  "save_flag"
    t.string   "save_scope"
    t.integer  "save_weight"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["saveable_id", "saveable_type", "save_scope"], name: "index_saves_on_saveable_id_and_saveable_type_and_save_scope"
    t.index ["saver_id", "saver_type", "save_scope"], name: "index_saves_on_saver_id_and_saver_type_and_save_scope"
  end

  create_table "sessions", force: :cascade do |t|
    t.string   "new"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "trading_posts", force: :cascade do |t|
    t.string   "title"
    t.text     "notes"
    t.integer  "price"
    t.string   "role"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.integer  "user_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "username"
    t.string   "oauth_token"
    t.string   "email"
    t.boolean  "admin",               default: false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.datetime "oauth_expires_at"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  create_table "votes", force: :cascade do |t|
    t.string   "votable_type"
    t.integer  "votable_id"
    t.string   "voter_type"
    t.integer  "voter_id"
    t.boolean  "vote_flag"
    t.string   "vote_scope"
    t.integer  "vote_weight"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["votable_id", "votable_type", "vote_scope"], name: "index_votes_on_votable_id_and_votable_type_and_vote_scope"
    t.index ["voter_id", "voter_type", "vote_scope"], name: "index_votes_on_voter_id_and_voter_type_and_vote_scope"
  end

end
