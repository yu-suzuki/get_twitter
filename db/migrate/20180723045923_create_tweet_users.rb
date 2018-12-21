class CreateTweetUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :tweet_users do |t|
      t.integer :user_id, null: false, default: 0, limit: 8, unsigned: true, unique: true
      t.string :name
      t.string :email
      t.string :screen_name
      t.string :location
      t.string :url
      t.string :description, limit: 4000
      t.boolean :verified, null: false, default: false
      t.integer :followers_count
      t.integer :friends_count
      t.integer :listed_count
      t.string :time_zone
      t.string :lang
      t.integer :statuses_count
      t.integer :utc_offset

      t.timestamps
    end
    add_index :tweet_users, :user_id, unique: true
  end
end
