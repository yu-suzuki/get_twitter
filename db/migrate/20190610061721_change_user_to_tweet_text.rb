class ChangeUserToTweetText < ActiveRecord::Migration[5.2]
  def change
    change_column_null :tweet_texts, :user_id, false, 0
  end
end
