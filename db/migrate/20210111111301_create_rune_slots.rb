class CreateRuneSlots < ActiveRecord::Migration[6.0]
  def change
    create_table :rune_slots do |t|
      t.integer :rune_tree_id
      t.integer :slot_index

      t.timestamps
    end
  end
end
