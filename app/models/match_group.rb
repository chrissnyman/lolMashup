class MatchGroup < ApplicationRecord
    belongs_to :game_mode, optional: true
    has_many :summoner_match_groups
    has_many :summoners, :through => :summoner_match_groups
    has_many :roll_results, :through => :summoner_match_groups

    before_create :set_uuid

    attr_accessor :team_count
    attr_accessor :team1_player_count
    attr_accessor :team2_player_count
    attr_accessor :filled_roles
    attr_accessor :available_roles

    def set_uuid
        self.uuid = SecureRandom.uuid unless self.uuid.present?
    end

    def reset
        self.filled_roles = {
            team1: [],
            team2: [],
        }
        self.team_count = get_team_count
        self.available_roles = get_available_lane_roles
        self.team1_player_count = 0
        self.team2_player_count = 0
        
        self.summoner_match_groups.each do |summoner_match_group|
            team = roll_next_team
            lane_role = roll_lane_role(team)
            summoner_match_group.update!(lane_role_id: lane_role.id, team: team)
        end
    end

    def roll_next_team
        if self.team_count == 2 && self.team1_player_count > self.team2_player_count
            team = 2
            self.team2_player_count += 1
        else
            team = 1
            self.team1_player_count += 1
        end

        team
    end

    def roll_lane_role(team)
        lane_role_list = self.get_allowed_lane_roles(team)
        offset = rand(lane_role_list.count)
        lane_role = LaneRole.where(name: lane_role_list[offset]).first
        
        self.filled_roles[:team1] << lane_role.name if team == 1
        self.filled_roles[:team2] << lane_role.name if team == 2

        lane_role
    end

    def get_allowed_lane_roles(team)
        allowed_lane_roles = self.available_roles

        filled_roles = self.filled_roles[:team1] if team == 1
        filled_roles = self.filled_roles[:team2] if team == 2

        filled_roles.each do |cur_lane_role|
            allowed_lane_roles = remove_item_from_list(allowed_lane_roles,cur_lane_role)
        end

        allowed_lane_roles
    end

    def remove_item_from_list(list,remove_item)
        new_list = []
        removed = false
        list.each do |cur_item|
            if removed == true or cur_item != remove_item
                new_list << cur_item 
            else
                removed = true
            end
        end
        new_list
    end
    
    def get_available_lane_roles
        no_jungle = false
        no_jungle = true if self.game_mode.name.include? 'No Jungle'
        
        if no_jungle
            role_list = LaneRole.where.not(name: 'Jungle').pluck(:name) + ['Top']
        else
            role_list = LaneRole.all.pluck(:name)
        end

        role_count = 0
        allowed_lane_roles = []
        role_list.shuffle.each do |cur_role|
            allowed_lane_roles << cur_role if role_count < self.size
            role_count += self.team_count
        end
        
        allowed_lane_roles
    end
    
    def get_team_count
        team_count = 1
        case self.game_mode.name
            when 'No Rules'
                team_count = 2 if self.size > 5
            when 'Classic 5v5'
                team_count = 2 if self.size > 5
            when 'Classic 5v5 (No Jungle)'
                team_count = 2 if self.size > 5
            when 'Custom'
                team_count = 2 if self.size > 5
            when 'Custom (No Jungle)'
                team_count = 2 if self.size > 5
            when 'Mirrored 5v5'
                team_count = 2
            when 'Mirrored (No Jungle)'
                team_count = 2
        end
        
        team_count
    end

    def self.validate_group_mode(game_mode_id, group_size)
        error = ""

        if game_mode_id.present?
            new_mode = GameMode.find(game_mode_id)
            
            error = "<strong>#{new_mode.name}</strong> can only be played with an even amount of players" if new_mode.even_player_count_needed and group_size % 2 != 0
            error = "<strong>#{new_mode.name}</strong> needs a group size of <strong>#{new_mode.min_players}</strong> players" if group_size < new_mode.min_players
        else
            error = "Invalid game mode selected"
        end

        error
    end
end
