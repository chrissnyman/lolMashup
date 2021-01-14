class CreateJoinTableGameModeRules < ActiveRecord::Migration[6.0]
  def change
    create_join_table :game_modes, :rules do |t|
      # t.index [:game_mode_id, :rule_id]
      # t.index [:rule_id, :game_mode_id]
    end
  end
end
