task :refresh_metadata, [:get_list_type] => [:environment] do |task,args|
    
    ddragon = ::Riot::DataDragon.new

    get_list_type = "All"
    get_list_type = args[:get_list_type] if args[:get_list_type].present?

    ddragon.check_latest_version
    
    ddragon.refresh_champion_list if get_list_type == "All" or get_list_type == "refresh_champion_list"

    ddragon.refresh_item_list if get_list_type == "All" or get_list_type == "refresh_item_list"
    
    ddragon.refresh_summoner_spell_list if get_list_type == "All" or get_list_type == "refresh_summoner_spell_list"

    ddragon.refresh_rune_list if get_list_type == "All" or get_list_type == "refresh_rune_list"
    

  end