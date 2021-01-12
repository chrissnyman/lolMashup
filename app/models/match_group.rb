class MatchGroup < ApplicationRecord
    belongs_to :game_mode
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
        self.available_roles = get_available_lane_roles
        self.team_count = get_team_count
        self.team1_player_count = 0
        self.team2_player_count = 0
        
        self.summoner_match_groups.each do |summoner_match_group|
            summoner_match_group.roll_result.update!(lane_role_id: nil) if summoner_match_group.roll_result.present?
        end
    end
    
    def get_available_lane_roles

        no_jungle = false
        case self.game_mode.name
            when 'Classic 5v5 (No Jungle)'
                no_jungle = true
            when 'Custom (No Jungle)'
                no_jungle = true
            when 'Mirrored (No Jungle)'
                no_jungle = true
        end
        
        if no_jungle
            allowed_lane_roles = {
                team1: (LaneRole.where.not(name: 'Jungle') + LaneRole.where(name: 'Top')).to_a,
                team2: (LaneRole.where.not(name: 'Jungle') + LaneRole.where(name: 'Top')).to_a,
            }
        else
            allowed_lane_roles = {
                team1: LaneRole.all.to_a,
                team2: LaneRole.all.to_a,
            }
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

    def get_allowed_lane_roles(team)
        return self.available_roles[:team1] if team == 1
        return self.available_roles[:team2] if team == 2
    end

    def remove_lane_role(team,lane_role)
        if team == 1
            self.available_roles[:team1] = remove_item_from_list(self.available_roles[:team1],lane_role)
        else
            self.available_roles[:team2] = remove_item_from_list(self.available_roles[:team2],lane_role)
        end
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
