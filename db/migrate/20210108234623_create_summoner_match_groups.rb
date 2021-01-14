class CreateSummonerMatchGroups < ActiveRecord::Migration[6.0]
  def change
    create_table :summoner_match_groups do |t|
      t.integer :summoner_id
      t.integer :match_group_id
      t.integer :lane_role_id
      t.integer :team

      t.timestamps
    end
  end
end
