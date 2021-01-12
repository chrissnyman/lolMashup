class MatchGroup < ApplicationRecord
    belongs_to :game_mode
    has_many :summoner_match_groups
    has_many :summoners, :through => :summoner_match_groups
    has_many :roll_results, :through => :summoner_match_groups

    before_create :set_uuid

    def set_uuid
        self.uuid = SecureRandom.uuid unless self.uuid.present?
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
