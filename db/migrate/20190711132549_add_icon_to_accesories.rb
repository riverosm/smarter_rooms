class AddIconToAccesories < ActiveRecord::Migration[5.2]
  def change
    add_column :accesories, :icon, :string
  end
end
