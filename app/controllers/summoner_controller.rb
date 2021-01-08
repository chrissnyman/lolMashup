class SummonerController < ApplicationController

    def search
        redirect_to "/summoner/#{params[:region]}/#{params[:summoner_name]}"

    end

    def overview
        api_client = ::Riot::ApiClient.new
        @region = params[:region]
        @summoner_name = params[:summoner_name]

        @summoner_data = api_client.get_summoner_data(@region,@summoner_name)
        @summoner_champ_masteries = []
        
        summoner_champ_masteries_data = api_client.get_summoner_champ_masteries(@region,@summoner_data["id"])
        summoner_champ_masteries_data.each do |cur_champ_data|
            champ = Champion.find(cur_champ_data["championId"])
            @summoner_champ_masteries << {
                name: champ.name,
                imagename: champ.imagename,
                championLevel: cur_champ_data["championLevel"],
                lastPlayTime: Time.at(cur_champ_data["lastPlayTime"]/1000),
                championPointsSinceLastLevel: cur_champ_data["championPointsSinceLastLevel"],
                championPointsUntilNextLevel: cur_champ_data["championPointsUntilNextLevel"],
                chestGranted: cur_champ_data["chestGranted"],
                tokensEarned: cur_champ_data["tokensEarned"],
                championPoints: cur_champ_data["championPoints"],
                championPoints: cur_champ_data["championPoints"],
            }
        end
    end
    
end
