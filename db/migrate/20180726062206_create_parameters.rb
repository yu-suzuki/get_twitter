class CreateParameters < ActiveRecord::Migration[5.2]
  def change
    create_table :parameters do |t|
      t.string :lang, null: false, default: "ja,en"
      t.string :consumer_key, null: false
      t.string :consumer_secret, null: false
      t.string :access_token, null: false
      t.string :access_token_secret, null: false

      t.timestamps
    end
  end
end
