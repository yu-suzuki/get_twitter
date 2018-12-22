class RemoveEmailFromTweetUser < ActiveRecord::Migration[5.2]
  def change
    remove_column :tweet_users, :email
  end
end
