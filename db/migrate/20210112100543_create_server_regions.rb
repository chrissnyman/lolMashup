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

    ServerRegion.create(region_code:"EUN1", name: "EUN")
    ServerRegion.create(region_code:"EUW1", name: "EUW")
    ServerRegion.create(region_code:"JP1", name: "JP")
    ServerRegion.create(region_code:"KR", name: "KR")
    ServerRegion.create(region_code:"LA1", name: "LA1")
    ServerRegion.create(region_code:"LA2", name: "LA2")
    ServerRegion.create(region_code:"NA1", name: "NA")
    ServerRegion.create(region_code:"OC1", name: "OC")
    ServerRegion.create(region_code:"TR1", name: "TR")
    ServerRegion.create(region_code:"RU", name: "RU")
  end
end
