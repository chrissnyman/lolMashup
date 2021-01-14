class GameMode < ApplicationRecord
    has_many :match_groups
    has_many :game_mode_rules
    has_and_belongs_to_many :rules

end
