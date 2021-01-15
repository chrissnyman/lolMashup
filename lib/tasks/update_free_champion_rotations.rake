task :update_free_champion_rotations, [:meta_version] => [:environment] do |task,args|
    
    riot_api = ::Riot::ApiClient.new

    ServerRegion.all.each do |cur_region|
      # puts "get champ rotation for #{cur_region.name}"
      free_champs = riot_api.get_free_champion_rotation(cur_region.region_code)
      cur_region.free_champion_ids = free_champs["freeChampionIds"].join(',')
      cur_region.save!
    end
  end