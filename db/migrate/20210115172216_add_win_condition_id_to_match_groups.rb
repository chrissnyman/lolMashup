class AddWinConditionIdToMatchGroups < ActiveRecord::Migration[6.0]
  def change
    add_column :match_groups, :win_condition_id, :integer
  end
end
