class CreateLabels < ActiveRecord::Migration[5.2]
  def change
    create_table :labels do |t|
      t.references :tweet_text, foreign_key: true
      t.string :label, null: false

      t.timestamps
    end
  end
end
