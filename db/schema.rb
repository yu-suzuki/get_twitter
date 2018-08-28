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

ActiveRecord::Schema.define(version: 2018_08_28_080654) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "hash_tags", force: :cascade do |t|
    t.string "tag", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "media", force: :cascade do |t|
    t.bigint "tweet_text_id"
    t.string "filename", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "url", default: "", null: false
    t.boolean "downloaded", default: false, null: false
    t.string "subdir"
    t.index ["downloaded"], name: "index_media_on_downloaded"
    t.index ["tweet_text_id", "filename"], name: "index_media_on_tweet_text_id_and_filename", unique: true
    t.index ["tweet_text_id"], name: "index_media_on_tweet_text_id"
  end

  create_table "recent_hash_tags", force: :cascade do |t|
    t.bigint "hash_tag_id"
    t.integer "count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hash_tag_id"], name: "index_recent_hash_tags_on_hash_tag_id"
  end

  create_table "recent_urls", force: :cascade do |t|
    t.bigint "url_id"
    t.integer "count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["url_id"], name: "index_recent_urls_on_url_id"
  end

  create_table "tweet_texts", force: :cascade do |t|
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
    t.bigint "user_id"
    t.index ["created_at"], name: "index_tweet_texts_on_created_at"
    t.index ["deleted"], name: "index_tweet_texts_on_deleted"
    t.index ["in_reply_to_status_id"], name: "index_tweet_texts_on_in_reply_to_status_id"
    t.index ["in_reply_to_user_id"], name: "index_tweet_texts_on_in_reply_to_user_id"
    t.index ["reply"], name: "index_tweet_texts_on_reply"
    t.index ["reply_check"], name: "index_tweet_texts_on_reply_check"
    t.index ["retweet", "reply"], name: "index_tweet_texts_on_retweet_and_reply"
    t.index ["retweet"], name: "index_tweet_texts_on_retweet"
    t.index ["tweet_user_id"], name: "index_tweet_texts_on_tweet_user_id"
    t.index ["updated_at"], name: "index_tweet_texts_on_updated_at"
    t.index ["user_id"], name: "index_tweet_texts_on_user_id"
  end

  create_table "tweet_users", force: :cascade do |t|
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
  end

  create_table "tweets_hash_tags", force: :cascade do |t|
    t.bigint "hash_tag_id"
    t.bigint "tweet_text_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hash_tag_id"], name: "index_tweets_hash_tags_on_hash_tag_id"
    t.index ["tweet_text_id", "hash_tag_id"], name: "index_tweets_hash_tags_on_tweet_text_id_and_hash_tag_id", unique: true
    t.index ["tweet_text_id"], name: "index_tweets_hash_tags_on_tweet_text_id"
  end

  create_table "tweets_urls", force: :cascade do |t|
    t.bigint "tweet_text_id"
    t.bigint "url_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tweet_text_id", "url_id"], name: "index_tweets_urls_on_tweet_text_id_and_url_id", unique: true
    t.index ["tweet_text_id"], name: "index_tweets_urls_on_tweet_text_id"
    t.index ["url_id"], name: "index_tweets_urls_on_url_id"
  end

  create_table "urls", force: :cascade do |t|
    t.string "url", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_mentions", force: :cascade do |t|
    t.bigint "tweet_text_id"
    t.bigint "tweet_user_id", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tweet_text_id", "tweet_user_id"], name: "index_user_mentions_on_tweet_text_id_and_tweet_user_id", unique: true
    t.index ["tweet_text_id"], name: "index_user_mentions_on_tweet_text_id"
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
