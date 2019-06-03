class CreateParameters < ActiveRecord::Migration[5.2]
  def change
    create_table :parameters do |t|
      t.string :key, null: false
      t.integer :value_int
      t.float :value_float
      t.string :value_string

      t.timestamps
    end
    add_index :parameters, :key, unique: true
  end
end
