class SetNameInBuildingsUniq < ActiveRecord::Migration[5.2]
  def change
    change_column :buildings, :name, :string, unique: true
  end
end
