class CreateRecentHashTags < ActiveRecord::Migration[5.2]
  def change
    create_table :recent_hash_tags do |t|
      t.references :hash_tag, foreign_key: true
      t.integer :count, null:false, default: 0

      t.timestamps
    end
  end
end
