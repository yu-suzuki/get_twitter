class CreateUserMentions < ActiveRecord::Migration[5.2]
  def change
    create_table :user_mentions do |t|
      t.references :tweet_text, foreign_key: true
      t.bigint :tweet_user_id, null: false, default: 0, unsigned: true

      t.timestamps
    end
  end
end
