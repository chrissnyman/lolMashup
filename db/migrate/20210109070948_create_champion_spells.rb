class CreateChampionSpells < ActiveRecord::Migration[6.0]
  def change
    create_table :champion_spells do |t|
      t.integer :champion_id
      t.string :spell_id
      t.string :name
      t.string :imagename
      
      t.timestamps
    end
  end
end
