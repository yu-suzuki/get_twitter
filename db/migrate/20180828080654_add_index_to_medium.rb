class AddIndexToMedium < ActiveRecord::Migration[5.2]
  def change
    add_index :media, [:tweet_text_id, :filename], unique: true
    add_index :user_mentions, [:tweet_text_id, :tweet_user_id], unique: true
  end
end
