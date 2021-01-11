class CreateGameModes < ActiveRecord::Migration[6.0]
  def change
    create_table :game_modes do |t|
      t.string :name
      t.integer :min_players, :default => 1
      t.boolean :even_player_count_needed, :default => false

      t.timestamps
    end
  end
end
