class AddIndexToTweetTexts < ActiveRecord::Migration[5.2]
  def change
    add_index :tweet_texts, :created_at
    add_index :tweet_texts, :updated_at
  end
end
