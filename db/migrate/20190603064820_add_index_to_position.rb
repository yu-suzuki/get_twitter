class AddIndexToPosition < ActiveRecord::Migration[5.2]
  def change
    add_index :tweet_texts, :position, using: :gist
  end
end
