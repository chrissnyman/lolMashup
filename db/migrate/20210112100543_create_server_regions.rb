class CreateServerRegions < ActiveRecord::Migration[6.0]
  def down
    drop_table :server_regions
  end
  
  def up
    create_table :server_regions do |t|
      t.string :name
      t.string :region_code

      t.timestamps
    end
  end
end
