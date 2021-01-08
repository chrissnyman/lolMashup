task :get_summoner_test, [:meta_version] => [:environment] do |task,args|
    
    riot_api = ::Riot::ApiClient.new

    summ_data = riot_api.get_summoner_data('EUW1','Arkhaenon')

    puts ""
    puts ""
    puts ""
    puts summ_data
    puts ""
    puts ""
    puts ""
    puts ""
  end