class CreateRoomAccesories < ActiveRecord::Migration[5.2]
  def change
    create_table :room_accesories do |t|
      t.integer :quantity
      t.references :room, foreign_key: true
      t.references :accesorie, foreign_key: true

      t.timestamps
    end
  end
end
