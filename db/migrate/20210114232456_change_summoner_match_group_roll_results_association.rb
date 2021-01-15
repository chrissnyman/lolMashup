class ChangeSummonerMatchGroupRollResultsAssociation < ActiveRecord::Migration[6.0]
  def change
    remove_column :roll_results, :summoner_match_group_id, :integer
    add_column :summoner_match_groups, :roll_result_id, :integer
  end
end
