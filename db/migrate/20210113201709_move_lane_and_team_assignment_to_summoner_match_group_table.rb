class MoveLaneAndTeamAssignmentToSummonerMatchGroupTable < ActiveRecord::Migration[6.0]
  def change
    remove_column :roll_results, :team, :string
    remove_column :roll_results, :lane_role_id, :string
    add_column :summoner_match_groups, :lane_role_id, :integer
    add_column :summoner_match_groups, :team, :string
  end
end
