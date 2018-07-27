class RemoveTweetIdFromTweetText < ActiveRecord::Migration[5.2]
  def change
    remove_column :tweet_texts, :tweet_id, null: false, default: 0, limit: 8, unsigned: true, unique: true
    remove_column :tweet_users, :user_id, null: false, default: 0, limit: 8, unsigned: true, unique: true
    add_reference :tweet_texts, :user
  end
end
