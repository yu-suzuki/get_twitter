class CreateTweets < ActiveRecord::Migration[5.2]
  def change
    create_table :tweet_texts do |t|
      t.integer :tweet_id, null: false, default: 0, limit: 8, unsigned: true, unique: true
      t.integer :favorite_count, null: false, default: 0, unsigned: true
      t.string :filter_level, null: false
      t.string :in_reply_to_screen_name, null: true, default: nil
      t.integer :in_reply_to_status_id, null: true, default: nil, limit: 8, unsigned: true
      t.integer :in_reply_to_user_id, null: true, default: nil, limit: 8, unsigned: true
      t.string :lang, null: false
      t.integer :retweet_count, null: false, default: 0, unsigned: true
      t.string :source, null: true, default: nil
      t.string :text, null: false

      t.timestamps
    end
    add_index :tweet_texts, :tweet_id, unique: true
    add_index :tweet_texts, :in_reply_to_status_id
    add_index :tweet_texts, :in_reply_to_user_id
  end
end
