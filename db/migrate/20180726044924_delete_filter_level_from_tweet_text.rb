class DeleteFilterLevelFromTweetText < ActiveRecord::Migration[5.2]
  def change
    remove_column :tweet_texts, :filter_level
  end
end
