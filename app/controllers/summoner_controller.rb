class SummonerController < ApplicationController

    def search
        redirect_to "/summoner/#{params[:region]}/#{params[:summoner_name]}"
    end

    def overview
        if params[:region].present? and params[:summoner_name].present?
            @region = params[:region]
            @summoner_name = params[:summoner_name]

            @summoner = Summoner.load_summoner(@region,@summoner_name)
            flash[:notice] =  {"title" => "Reload summmoner data", "message"=> "could not reload summoner data...", "class"=>"danger"} if @summoner.failed_to_reload == true
        end
    end

    def refresh
        if params[:region].present? and params[:summoner_name].present?
            @region = params[:region]
            @summoner_name = params[:summoner_name]

            @summoner = Summoner.load_summoner(@region,@summoner_name, true)
        end
        
        redirect_to "/summoner/#{params[:region]}/#{params[:summoner_name]}"
    end

end
