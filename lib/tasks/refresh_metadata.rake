task :refresh_metadata, [:meta_version] => [:environment] do |task,args|
    
            ddragon = ::Riot::DataDragon.new

    champions_data = ddragon.get_champions

    puts ""
    puts "Found #{champions_data["data"].count} champions"
    puts ""
    puts ""
    champions_data["data"].each do |champ_name,champ_data|

      # puts "#{champ_name}: #{champ_data}"
    end
    puts ""
    puts ""
    puts ""
    puts ""
  end