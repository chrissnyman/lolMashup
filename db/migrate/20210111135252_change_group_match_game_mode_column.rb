class ChangeGroupMatchGameModeColumn < ActiveRecord::Migration[6.0]
  def change
    remove_column :match_groups, :mode, :string
    add_column :match_groups, :game_mode_id, :integer
  end
end
