class CreateUrls < ActiveRecord::Migration[5.2]
  def change
    create_table :urls do |t|
      t.string :url, null: false, limit: 4000
      t.timestamps
    end
  end
end
