class AdDeletedIndexToTweetText < ActiveRecord::Migration[5.2]
  def change
    add_index :tweet_texts, :deleted
    add_index :media, :downloaded
  end
end
