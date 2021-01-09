class CreateSummonerSpells < ActiveRecord::Migration[6.0]
  def change
    create_table :summoner_spells do |t|
      t.string :spell_id
      t.string :name
      t.string :imagename
      t.string :modes

      t.timestamps
    end
  end
end
