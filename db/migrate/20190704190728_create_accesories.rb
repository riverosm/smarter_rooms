class CreateAccesories < ActiveRecord::Migration[5.2]
  def change
    create_table :accesories do |t|
      t.string :name

      t.timestamps
    end
    add_index :accesories, :name, unique: true
  end
end
