class CreateTweetsUrls < ActiveRecord::Migration[5.2]
  def change
    create_table :tweets_urls do |t|
      t.references :tweet_text, foreign_key: true
      t.references :url, foreign_key: true

      t.timestamps
    end
  end
end
