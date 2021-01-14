class Rule < ApplicationRecord
    has_and_belongs_to_many :game_modes
end
