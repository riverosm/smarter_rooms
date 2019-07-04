class CreateRooms < ActiveRecord::Migration[5.2]
  def change
    create_table :rooms do |t|
      t.string :name
      t.string :code
      t.integer :floor
      t.integer :max_capacity
      t.boolean :active
      t.references :building, foreign_key: true

      t.timestamps
    end
    add_index :rooms, :code, unique: true
  end
end
