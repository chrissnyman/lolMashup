class CreateStatMods < ActiveRecord::Migration[6.0]
  def change
    create_table :stat_mods do |t|
      t.string :name
      t.string :icon
      t.string :allowed_in_slot
      
      t.timestamps
    end
  end
end
