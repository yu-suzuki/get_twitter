class AddRetweetedToTweetText < ActiveRecord::Migration[5.2]
  def change
    add_column :tweet_texts, :retweet, :boolean, null: false, default: false
    add_column :tweet_texts, :reply, :boolean, null: false, default: false
    add_column :tweet_texts, :position, :st_point, geographic: true
  end
end
