class AddUserToTweet < ActiveRecord::Migration[5.2]
  def change
    add_reference :tweet_texts, :tweet_user, index: true
  end
end
