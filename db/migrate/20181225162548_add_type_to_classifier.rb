class AddTypeToClassifier < ActiveRecord::Migration[5.2]
  def change
    add_column :classifiers, :type, :string, null: false

  end
end
