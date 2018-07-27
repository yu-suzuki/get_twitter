class AddSubdirToMedia < ActiveRecord::Migration[5.2]
  def change
    add_column :media, :subdir, :string
  end
end
