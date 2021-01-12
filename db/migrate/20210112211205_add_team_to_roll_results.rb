class AddTeamToRollResults < ActiveRecord::Migration[6.0]
  def change
    add_column :roll_results, :team, :string
  end
end
