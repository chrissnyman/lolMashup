class GroupController < ApplicationController

    def new
    end
    
    def create
        match = MatchGroup.create(match_group_params)
        if match.present?
            redirect_to "/group/#{match.uuid}"
        else
            flash[:notice] = 'Could not create group, sorry...'
            redirect_to :back
        end
    end

    def show
        @group = MatchGroup.where(uuid: params[:uuid]).first
        unless @group.present?
            flash[:notice] = {message: "Group not found", class: 'warning'}
            redirect_to "/group/new"
        end
    end

    def add_summoner
        group = MatchGroup.where(uuid: params[:uuid]).first
        summoner = Summoner.load_summoner(params[:region], params[:summoner_name])

        if summoner.present?
            existing_summoner_match_group = SummonerMatchGroup.where({summoner_id: summoner.id, match_group_id: group.id}).first

            if existing_summoner_match_group.present?
                flash[:notice] = {message: "#{summoner.name} already added", class: 'warning'}
            else
                new_summoner_match_group = SummonerMatchGroup.create!({summoner_id: summoner.id, match_group_id: group.id})
                flash[:notice] = {message: "#{summoner.name} added", class: 'success'}
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
        redirect_to "/group/#{group.uuid}"
    end
    
    private
        def match_group_params
            params.permit(:name, :password, :size, :region)
        end

end
