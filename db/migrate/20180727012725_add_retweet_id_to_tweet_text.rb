class AddRetweetIdToTweetText < ActiveRecord::Migration[5.2]
  def change
    add_column :tweet_texts, :retweet_id, :integer, limit: 8, unsigned: true
  end
end
