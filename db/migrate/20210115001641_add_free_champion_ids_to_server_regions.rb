class AddFreeChampionIdsToServerRegions < ActiveRecord::Migration[6.0]
  def change
    add_column :server_regions, :free_champion_ids, :string
  end
end
