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

ActiveRecord::Schema.define(version: 2018_07_27_012725) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "fuzzystrmatch"
  enable_extension "plpgsql"
  enable_extension "postgis"
  enable_extension "postgis_tiger_geocoder"
  enable_extension "postgis_topology"

  create_table "parameters", force: :cascade do |t|
    t.string "lang", default: "ja,en", null: false
    t.string "consumer_key", null: false
    t.string "consumer_secret", null: false
    t.string "access_token", null: false
    t.string "access_token_secret", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tweet_texts", force: :cascade do |t|
    t.bigint "tweet_id", default: 0, null: false
    t.integer "favorite_count", default: 0, null: false
    t.string "in_reply_to_screen_name"
    t.bigint "in_reply_to_status_id"
    t.bigint "in_reply_to_user_id"
    t.string "lang", null: false
    t.integer "retweet_count", default: 0, null: false
    t.string "source"
    t.string "text", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "tweet_user_id"
    t.boolean "reply_check", default: false
    t.boolean "deleted", default: false, null: false
    t.boolean "retweet", default: false, null: false
    t.boolean "reply", default: false, null: false
    t.geography "position", limit: {:srid=>4326, :type=>"st_point", :geographic=>true}
    t.bigint "retweet_id"
    t.index ["in_reply_to_status_id"], name: "index_tweet_texts_on_in_reply_to_status_id"
    t.index ["in_reply_to_user_id"], name: "index_tweet_texts_on_in_reply_to_user_id"
    t.index ["reply_check"], name: "index_tweet_texts_on_reply_check"
    t.index ["tweet_id"], name: "index_tweet_texts_on_tweet_id", unique: true
    t.index ["tweet_user_id"], name: "index_tweet_texts_on_tweet_user_id"
  end

  create_table "tweet_users", force: :cascade do |t|
    t.bigint "user_id", default: 0, null: false
    t.string "name"
    t.string "email"
    t.string "screen_name"
    t.string "location"
    t.string "url"
    t.string "description"
    t.boolean "verified", default: false, null: false
    t.integer "followers_count"
    t.integer "friends_count"
    t.integer "listed_count"
    t.string "time_zone"
    t.string "lang"
    t.integer "statuses_count"
    t.integer "utc_offset"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_tweet_users_on_user_id", unique: true
  end

end
