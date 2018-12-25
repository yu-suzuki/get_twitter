class CreateClassifiers < ActiveRecord::Migration[5.2]
  def change
    create_table :classifiers do |t|
      t.string :name, null: false

      t.timestamps
    end
    add_index :classifiers, :created_at
  end
end
