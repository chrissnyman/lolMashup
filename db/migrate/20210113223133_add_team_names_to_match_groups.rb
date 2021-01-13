class AddTeamNamesToMatchGroups < ActiveRecord::Migration[6.0]
  def change
    add_column :match_groups, :team1_name, :string, :default => 'Blue Team'
    add_column :match_groups, :team2_name, :string, :default => 'Red Team'
  end
end
