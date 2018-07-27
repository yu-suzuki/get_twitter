class AddDeletedToTweetText < ActiveRecord::Migration[5.2]
  def change
    add_column :tweet_texts, :deleted, :boolean, default: false, null: false
  end
end
