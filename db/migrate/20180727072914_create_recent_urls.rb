class CreateRecentUrls < ActiveRecord::Migration[5.2]
  def change
    create_table :recent_urls do |t|
      t.references :url, foreign_key: true
      t.integer :count, null: false, default: 0

      t.timestamps
    end
  end
end
