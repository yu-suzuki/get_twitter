class CreateFollows < ActiveRecord::Migration[5.2]
  def change
    create_table :follows do |t|
      t.references :from_user
      t.references :to_user

      t.timestamps
    end
    add_foreign_key :follows, :tweet_users, column: :from_user_id
    add_foreign_key :follows, :tweet_users, column: :to_user_id
    add_index :follows, [:from_user_id, :to_user_id], unique: true
  end
end
