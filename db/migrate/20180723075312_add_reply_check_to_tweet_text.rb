class AddReplyCheckToTweetText < ActiveRecord::Migration[5.2]
  def change
    add_column :tweet_texts, :reply_check, :boolean, default: false
    add_index :tweet_texts, :reply_check
  end
end
