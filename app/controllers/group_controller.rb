class GroupController < ApplicationController

    def new
        @match_group_params = {
            region: 'EUW1',
            game_mode_id: GameMode.where(name: 'No Rules').first.id,
            size: 5,
        }
    end
    
    def create
        flash[:notice] = nil
        group_size = 0
        group_size = match_group_params[:size].to_i if match_group_params[:size].present?

        error = MatchGroup.validate_group_mode(match_group_params[:game_mode_id], group_size)
        if error == ""
            match = MatchGroup.create!(match_group_params)
            if match.present?
                redirect_to "/group/#{match.uuid}"
            else
                @match_group_params = match_group_params
                #we have to create the notice slightly different here as we are skipping a few built-in controller steps by rendering the 'new' page directly
                flash[:notice] =  {"message"=>error, "class"=>"danger"}
                render 'new'
            end
        else
            @match_group_params = match_group_params
            #we have to create the notice slightly different here as we are skipping a few built-in controller steps by rendering the 'new' page directly
            flash[:notice] =  {"message"=>error, "class"=>"danger"}
            render 'new'
        end
    end

    def show
        @group = MatchGroup.where(uuid: params[:uuid]).first
        @refresh_delay = 2000
        @refresh_delay = 10000 if @group.roll_results.count == @group.size
        
        unless @group.present?
            flash[:notice] = {message: "Group not found", class: 'warning'}
            redirect_to "/group/new"
        end
    end

    def add_summoner
        group = MatchGroup.where(uuid: params[:uuid]).first
        summoner = Summoner.load_summoner(params[:region], params[:summoner_name])

        if summoner.present?
            if summoner.champions.count > 0
            
                existing_summoner_match_group = SummonerMatchGroup.where({summoner_id: summoner.id, match_group_id: group.id}).first
                if existing_summoner_match_group.present?
                    flash[:notice] = {message: "#{summoner.name} already added", class: 'warning'}
                else
                    new_summoner_match_group = SummonerMatchGroup.create!({summoner_id: summoner.id, match_group_id: group.id})
                    group.update(updated_at: Time.now)
                    flash[:notice] = {message: "#{summoner.name} added", class: 'success'}
                end
            else
                flash[:notice] = {message: "#{summoner.name} does not have any champion masteries yet", class: 'danger'}
            end
        else
            flash[:notice] = {message: "Summoner not found", class: 'danger'}
        end

        redirect_to "/group/#{group.uuid}"
    end

    def roll
        group = MatchGroup.where(uuid: params[:uuid]).first
        group.summoner_match_groups.each do |summoner_match_group|
            summoner_match_group.roll_build 
        end
        group.update(updated_at: Time.now)
        redirect_to "/group/#{group.uuid}"
    end

    def get_last_updated
        group = MatchGroup.where(uuid: params[:uuid]).first
        puts "get_last_updated: #{group}"
        
        render json: group.updated_at.to_i
    end

    def change_game_mode
        group = MatchGroup.where(uuid: params[:uuid]).first
        error = MatchGroup.validate_group_mode(params[:game_mode_id], group.size)
        if error == ""
            if group.update(game_mode_id: params[:game_mode_id])
                # flash[:notice] = {message: "Summoner not found", class: 'success'}
            else
                flash[:notice] = {message: "Error updating game mode", class: 'danger'}
            end
        else
            flash[:notice] = {message: error, class: 'danger'}
        end
        redirect_to "/group/#{params[:uuid]}"
    end
    
    private
        def match_group_params
            params.permit(:name, :password, :size, :region, :game_mode_id)
        end

end
