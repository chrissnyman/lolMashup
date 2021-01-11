class CreateRunes < ActiveRecord::Migration[6.0]
  def change
    create_table :runes do |t|
      t.integer :rune_slot_id

      t.string :icon
      t.string :key
      t.string :name

      t.timestamps
    end
  end
end
