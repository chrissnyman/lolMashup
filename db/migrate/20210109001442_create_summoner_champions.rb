class CreateSummonerChampions < ActiveRecord::Migration[6.0]
  def change
    create_table :summoner_champions do |t|
      t.integer :summoner_id
      t.integer :champion_id

      t.integer :mastery_level
      t.integer :champion_points
      t.integer :champion_points_since_last
      t.integer :champion_points_to_next
      t.string :chest_granted
      t.string :tokens_earned
      t.datetime :last_play_time

      t.timestamps
    end
  end
end
