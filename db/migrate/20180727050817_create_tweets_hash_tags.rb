class CreateTweetsHashTags < ActiveRecord::Migration[5.2]
  def change
    create_table :tweets_hash_tags do |t|
      t.references :hash_tag, foreign_key: true
      t.references :tweet_text, foreign_key: true

      t.timestamps
    end
  end
end
