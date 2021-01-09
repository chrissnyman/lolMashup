task :refresh_metadata, [:meta_version] => [:environment] do |task,args|
    
    ddragon = ::Riot::DataDragon.new

    ddragon.refresh_champion_list

    ddragon.refresh_item_list
    
    ddragon.refresh_summoner_spell_list

  end