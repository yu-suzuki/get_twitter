class CreatePredictedLabels < ActiveRecord::Migration[5.2]
  def change
    create_table :predicted_labels do |t|
      t.references :classifier, foreign_key: true
      t.references :tweet_text, foreign_key: true
      t.string :label, null: false
      t.float :probability, null: false, default: 0

      t.timestamps
    end
  end
end
