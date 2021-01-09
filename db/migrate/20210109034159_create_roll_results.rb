class CreateRollResults < ActiveRecord::Migration[6.0]
  def change
    create_table :roll_results do |t|
      t.integer :summoner_match_group_id
      t.integer :champion_id
      t.integer :champion_spell_id
      t.string :item_build
      t.string :rune_build
      t.string :summoner_spells
      
      t.timestamps
    end
  end
end
