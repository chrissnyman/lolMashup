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

            summoner_match_group.team = team
            summoner_match_group.lane_role_id = lane_role.id
            summoner_match_group.roll_result_id = nil
            summoner_match_group.save!
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

    def is_mirrored?
        self.game_mode.name.include? 'Mirrored'
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
            when 'Mirrored'
                team_count = 2
            when 'Mirrored (No Jungle)'
                team_count = 2
        end
        
        team_count
    end

    def self.random_roll_message 
        messages = [
            'Scanning trashcan...',
            'Reaching for the depths of depravity...',
            'Finding worst possible combo...',
            'Let\'s see you make this work...',
            'Cooking up some bad soup...',
            'Calculating worst win rate team...',
        ]
        offset = rand(messages.count)

        messages[offset]
    end

    def self.validate_group_mode(match_group_params)
        errors = []

        if match_group_params[:game_mode_id].present?
            new_mode = GameMode.find(match_group_params[:game_mode_id])
            new_mode.rules.each do |rule|
                case rule.check_val
                    when 'player_count'
                        check_val = match_group_params[:size].to_i if match_group_params[:size].present?
                end

                next if check_val.blank?

                calc_parts = rule.check_calc.split(':')
                case calc_parts[0]
                    when 'eq_or'
                        errors << "<strong>#{new_mode.name}</strong> needs a group size of <strong>#{calc_parts[1]}</strong> or <strong>#{calc_parts[2]}</strong> players" if check_val != calc_parts[1].to_i and check_val != calc_parts[2].to_i
                    when 'min'
                        errors << "<strong>#{new_mode.name}</strong> needs a group size of <strong>#{calc_parts[1]}</strong> players" if check_val < calc_parts[1].to_i
                    when 'mod'
                        mod_reason = "with an <strong>even amount</strong> of players"
                        mod_reason = "with <strong>multiples of #{calc_parts[1]}<strong> players" if calc_parts[1].to_i != 2
                        errors << "<strong>#{new_mode.name}</strong> can only be played #{mod_reason} " if check_val % calc_parts[1].to_i != calc_parts[2].to_i
                end
            end
        else
            errors << "Invalid game mode selected"
        end

        errors.join('<br>')
    end
end
