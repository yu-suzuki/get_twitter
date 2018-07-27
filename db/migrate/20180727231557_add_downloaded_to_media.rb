class AddDownloadedToMedia < ActiveRecord::Migration[5.2]
  def change
    add_column :media, :downloaded, :boolean, null: false, default: false
  end
end
