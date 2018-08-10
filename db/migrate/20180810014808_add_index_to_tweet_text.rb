class AddIndexToTweetText < ActiveRecord::Migration[5.2]
  def change
    add_index :tweet_texts, :retweet
    add_index :tweet_texts, :reply
    add_index :tweet_texts, [:retweet, :reply]
  end
end
