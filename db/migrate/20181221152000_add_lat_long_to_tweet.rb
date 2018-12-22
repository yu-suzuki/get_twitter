class AddLatLongToTweet < ActiveRecord::Migration[5.2]
  def change
    add_column :tweet_texts, :latitude, :decimal
    add_column :tweet_texts, :longitude, :decimal
    #remove_column :tweet_texts, :user_id
  end
end
