class SummonerController < ApplicationController

    def overview
        api_client = ::Riot::ApiClient.new
        @region = params[:region]
        @summoner_name = params[:summoner_name]

        @summoner_data = api_client.get_summoner_data(@region,@summoner_name)
        @summoner_champ_masteries = api_client.get_summoner_champ_masteries(@region,@summoner_data["id"])
    end
    
end
