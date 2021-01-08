task :refresh_metadata, [:meta_version] => [:environment] do |task,args|
    
            ddragon = ::Riot::DataDragon.new

    champions_data = ddragon.get_champions

    puts ""
    puts "Found #{champions_data["data"].count} champions"
    puts ""
    puts ""
    champions_data["data"].each do |champ_name,champ_data|

      champ_obj = {
        id: champ_data["key"].to_i,
        name: champ_data["name"],
        imagename: champ_data["image"]["full"],
        image: champ_data["image"],
        info: champ_data["info"],
        partype: champ_data["partype"],
        tags: champ_data["tags"],
        title: champ_data["title"],
        stats: champ_data["stats"],
      }
      if Champion.where(id: champ_obj[:id]).count == 1
        Champion.find(champ_obj[:id]).update(champ_obj)
        puts "updating #{champ_obj[:name]}"
      else
        puts "creating #{champ_obj[:name]}"
        Champion.create(champ_obj)
      end
    end
    puts ""
    puts ""
    puts ""
    puts ""
  end