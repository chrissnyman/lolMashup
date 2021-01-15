class GroupController < ApplicationController
    before_action :set_group, :only => [:show,:edit,:roll, :post_match_results]

    def new
        
        @match_group_params = {
            name: Spicy::Proton.format('%b %a %n').titleize.gsub(' ',''),
            team1_name: 'Blue Team',
            team2_name: 'Red Team',
            region: 'EUW1',
            game_mode_id: GameMode.where(name: 'No Rules').first.id,
            size: 5,
        }
    end
    
    def edit
    end
    
    def create
        flash[:notice] = nil
        group_size = 0
        group_size = match_group_params[:size].to_i if match_group_params[:size].present?

        error = MatchGroup.validate_group_mode(match_group_params)
        if error == ""
            match = MatchGroup.create!(match_group_params)
            if match.present?
                redirect_to "/group/#{match.uuid}"
            else
                @match_group_params = match_group_params
                #we have to create the notice slightly different here as we are skipping a few built-in controller steps by rendering the 'new' page directly
                flash[:notice] =  {"title" => "Create Match Group", "message"=> "Error creating group...", "class"=>"danger"}
                render 'new'
            end
        else
            @match_group_params = match_group_params
            #we have to create the notice slightly different here as we are skipping a few built-in controller steps by rendering the 'new' page directly
            flash[:notice] =  {"title" => "Create Match Group", "message"=>error, "class"=>"danger"}
            render 'new'
        end
    end
    
    def update
        flash[:notice] = nil
        group_size = 0
        group_size = match_group_params[:size].to_i if match_group_params[:size].present?

        error = MatchGroup.validate_group_mode(match_group_params)
        if error == ""
            group_match = MatchGroup.where(uuid: params[:uuid]).first
            clear_summoners = false
            clear_summoners = true if match_group_params[:region] != group_match.region
            if group_match.update(match_group_params)
                redirect_to "/group/#{group_match.uuid}"
                flash[:notice] =  {"title" => "Update Match Group", "message"=>"Changes saved", "class"=>"success"}
                if clear_summoners
                    group_match.summoner_match_groups.delete_all
                    flash[:notice] =  {"title" => "Update Match Group", "message"=>"Changes saved, summoners removed due to region change", "class"=>"info"}
                end
            else
                @group = match_group_params
                #we have to create the notice slightly different here as we are skipping a few built-in controller steps by rendering the 'new' page directly
                flash[:notice] =  {"title" => "Error", "message"=>group_match.errors, "class"=>"danger"}
                render 'edit'
            end
        else
            @group = match_group_params
            #we have to create the notice slightly different here as we are skipping a few built-in controller steps by rendering the 'new' page directly
            flash[:notice] =  {"title" => "Error", "message"=>error, "class"=>"danger"}
            render 'edit'
        end
    end

    def show
        @refresh_delay = 2000
        @refresh_delay = 10000 if @group.roll_results.count == @group.size
        @roll_message = MatchGroup.random_roll_message
        unless @group.present?
            flash[:notice] = {title: "Error", message: "Group not found", class: 'warning'}
            redirect_to "/group/new"
        end
    end

    def list
    end

    def add_summoner
        group = MatchGroup.where(uuid: params[:uuid]).first
        summoner = Summoner.load_summoner(params[:region], params[:summoner_name])

        if summoner.present?
            if summoner.champions.count > 0
            
                existing_summoner_match_group = SummonerMatchGroup.where({summoner_id: summoner.id, match_group_id: group.id}).first
                if existing_summoner_match_group.present?
                    flash[:notice] = {title: "Add summoner", message: "#{summoner.name} already added", class: 'warning'}
                else
                    new_summoner_match_group = SummonerMatchGroup.create!({summoner_id: summoner.id, match_group_id: group.id})
                    group.update(updated_at: Time.now)
                    flash[:notice] = {title: "Add summoner", message: "#{summoner.name} added", class: 'success'}
                end
            else
                flash[:notice] = {title: "Add summoner", message: "#{summoner.name} does not have any champion masteries yet", class: 'danger'}
            end
        else
            flash[:notice] = {title: "Add summoner", message: "Summoner not found", class: 'danger'}
        end

        redirect_to "/group/#{group.uuid}"
    end
    
    def remove_summoner
        group = MatchGroup.where(uuid: params[:uuid]).first
        summoner_match_group = group.summoner_match_groups.where(id: params[:summoner_match_group_id]).first
        
        if summoner_match_group.present?
            if summoner_match_group.delete
                flash[:notice] = {title: "Remove summoner", message: "Summoner removed", class: 'success'}
            else
                flash[:notice] = {title: "Remove summoner", message: "Could not remove summoner", class: 'danger'}
            end
        else
            flash[:notice] = {title: "Remove summoner", message: "Summoner already removed", class: 'info'}
        end

        redirect_to "/group/#{group.uuid}"
    end
    
    def roll
        @group.reset
        if @group.is_mirrored?
            @group.summoner_match_groups.where(team: 1).each  do |summoner_match_group|
                mirror_with_summoner_match_group = @group.summoner_match_groups.where(team: 2, lane_role_id: summoner_match_group.lane_role_id, roll_result_id: nil).first
                summoner_match_group.roll_build(mirror_with_summoner_match_group)
                mirror_with_summoner_match_group.update(roll_result_id: summoner_match_group.roll_result_id)
            end
        else
            @group.summoner_match_groups.shuffle.each do |summoner_match_group|
                summoner_match_group.roll_build
            end
        end
        @group.update(updated_at: Time.now)
        return redirect_to "/group/#{@group.uuid}"
    end

    def get_last_updated
        group = MatchGroup.where(uuid: params[:uuid]).first
        puts "get_last_updated: #{group}"
        
        render json: group.updated_at.to_i
    end
    
    def post_match_results
        if params[:game_id].present?
            match_data = ::Riot::ApiClient.new.get_match_details(@group.region,params[:game_id])

        else
            query_start_time = (Time.now - 24.hour).to_i * 1000
            match_data = ::Riot::ApiClient.new.get_last_match_data(@group.region,@group.summoners.first.riot_account_id, query_start_time)
        end

        @match_player_data = []
        match_data["participantIdentities"].each do |participantIdentity|
            relevant_summoner = @group.summoners.where(riot_id: participantIdentity["player"]["summonerId"]).first
            
            if relevant_summoner.present?
                participant_data = nil
                match_data["participants"].each do |participant|
                    participant_data = participant if participant["participantId"] == participantIdentity["participantId"]
                end
                @match_player_data << {
                    summoner: relevant_summoner,
                    participantIdentity: participantIdentity,
                    participant_data: participant_data,
                    metric_score: nil
                }
            end
        end

        @winner = calculcate_winner

        # @full_match_data = match_data
    end
    
    def calculcate_winner
        winner = nil
        @match_player_data.each do |player_data|
            if winner.blank?
                winner = player_data
            else
                winner = compare_metric_winner(winner, player_data)
            end
        end
        return winner
    end
    
    def compare_metric_winner(current_winner, cur_player_data)
        # case @group.win_condition.
        current_winner_val = current_winner[:participant_data]["stats"][@group.win_condition.condition_metric]
        cur_player_data_val = cur_player_data[:participant_data]["stats"][@group.win_condition.condition_metric]
        current_winner[:metric_score] = current_winner_val
        cur_player_data[:metric_score] = cur_player_data_val

        if @group.win_condition.metric_calc_type == "asc"
            if current_winner_val < cur_player_data_val
                return current_winner
            else 
                return cur_player_data
            end
        else
            if current_winner_val < cur_player_data_val
                return current_winner
            else 
                return cur_player_data
            end
        end
    end


    private
        def match_group_params
            params.permit(:name, :password, :size, :region, :game_mode_id, :team1_name, :team2_name)
        end
        def set_group
            @group = MatchGroup.where(uuid: params[:uuid]).first

            unless @group.present?
                return redirect_to '/group/new', notice: {"title" => "Match Group", "message"=> "Could not find your match group", "class"=>"danger"}
            end
        end
end
