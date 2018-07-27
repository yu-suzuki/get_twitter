class AddUrlToMedium < ActiveRecord::Migration[5.2]
  def change
    add_column :media, :url, :string, null: false, default: ""
  end
end
