class SummonerController < ApplicationController

    def search
        redirect_to "/summoner/#{params[:region]}/#{params[:summoner_name]}"

    end

    def overview
        if params[:region].present? and params[:summoner_name].present?
            api_client = ::Riot::ApiClient.new
            @region = params[:region]
            @summoner_name = params[:summoner_name]

            @summoner = Summoner.load_summoner(@region,@summoner_name)
        end
    end
    
end
