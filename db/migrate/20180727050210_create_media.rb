class CreateMedia < ActiveRecord::Migration[5.2]
  def change
    create_table :media do |t|
      t.references :tweet_text, foreign_key: true
      t.string :filename, null: false

      t.timestamps
    end
  end
end
