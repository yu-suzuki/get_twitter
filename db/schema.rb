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

ActiveRecord::Schema.define(version: 2018_12_21_152000) do

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", precision: 38, default: 0, null: false
    t.integer "attempts", precision: 38, default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at", precision: 6
    t.datetime "locked_at", precision: 6
    t.datetime "failed_at", precision: 6
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "hash_tags", force: :cascade do |t|
    t.string "tag", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "media", force: :cascade do |t|
    t.integer "tweet_text_id", limit: 19, precision: 19
    t.string "filename", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "url", default: "", null: false
    t.boolean "downloaded", default: false, null: false
    t.string "subdir"
    t.index ["downloaded"], name: "index_media_on_downloaded"
    t.index ["tweet_text_id", "filename"], name: "i_media_tweet_text_id_filename", unique: true
    t.index ["tweet_text_id"], name: "index_media_on_tweet_text_id"
  end

  create_table "recent_hash_tags", force: :cascade do |t|
    t.integer "hash_tag_id", limit: 19, precision: 19
    t.integer "count", precision: 38, default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["hash_tag_id"], name: "i_recent_hash_tags_hash_tag_id"
  end

  create_table "recent_urls", force: :cascade do |t|
    t.integer "url_id", limit: 19, precision: 19
    t.integer "count", precision: 38, default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["url_id"], name: "index_recent_urls_on_url_id"
  end

# Could not dump table "tweet_texts" because of following StandardError
#   Unknown type 'PUBLIC.SDO_GEOMETRY' for column 'position'

  create_table "tweet_users", force: :cascade do |t|
    t.string "name"
    t.string "screen_name"
    t.string "location"
    t.string "url"
    t.string "description", limit: 4000
    t.boolean "verified", default: false, null: false
    t.integer "followers_count", precision: 38
    t.integer "friends_count", precision: 38
    t.integer "listed_count", precision: 38
    t.string "time_zone"
    t.string "lang"
    t.integer "statuses_count", precision: 38
    t.integer "utc_offset", precision: 38
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "tweets_hash_tags", force: :cascade do |t|
    t.integer "hash_tag_id", limit: 19, precision: 19
    t.integer "tweet_text_id", limit: 19, precision: 19
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["hash_tag_id"], name: "i_tweets_hash_tags_hash_tag_id"
    t.index ["tweet_text_id", "hash_tag_id"], name: "i3ce6a75e51d808dab083d2bec1bee", unique: true
    t.index ["tweet_text_id"], name: "i_twe_has_tag_twe_tex_id"
  end

  create_table "tweets_urls", force: :cascade do |t|
    t.integer "tweet_text_id", limit: 19, precision: 19
    t.integer "url_id", limit: 19, precision: 19
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["tweet_text_id", "url_id"], name: "i_twe_url_twe_tex_id_url_id", unique: true
    t.index ["tweet_text_id"], name: "i_tweets_urls_tweet_text_id"
    t.index ["url_id"], name: "index_tweets_urls_on_url_id"
  end

  create_table "urls", force: :cascade do |t|
    t.string "url", limit: 4000, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "user_mentions", force: :cascade do |t|
    t.integer "tweet_text_id", limit: 19, precision: 19
    t.integer "tweet_user_id", limit: 19, precision: 19, default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["tweet_text_id", "tweet_user_id"], name: "ibf4b918af69ce4b9c83f87a7d11a3", unique: true
    t.index ["tweet_text_id"], name: "i_user_mentions_tweet_text_id"
  end

  add_foreign_key "media", "tweet_texts"
  add_foreign_key "recent_hash_tags", "hash_tags"
  add_foreign_key "recent_urls", "urls"
  add_foreign_key "tweets_hash_tags", "hash_tags"
  add_foreign_key "tweets_hash_tags", "tweet_texts"
  add_foreign_key "tweets_urls", "tweet_texts"
  add_foreign_key "tweets_urls", "urls"
  add_foreign_key "user_mentions", "tweet_texts"
end
