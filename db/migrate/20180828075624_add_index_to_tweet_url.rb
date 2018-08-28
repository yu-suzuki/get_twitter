class AddIndexToTweetUrl < ActiveRecord::Migration[5.2]
  def change
    add_index :tweets_urls, [:tweet_text_id, :url_id], unique: true
    add_index :tweets_hash_tags, [:tweet_text_id, :hash_tag_id], unique: true
  end
end
