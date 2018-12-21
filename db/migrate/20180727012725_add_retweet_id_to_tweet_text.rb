class AddRetweetIdToTweetText < ActiveRecord::Migration[5.2]
  def change
    add_column :tweet_texts, :retweet_id, :bigint, unsigned: true
  end
end
