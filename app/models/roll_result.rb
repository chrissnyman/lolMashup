class RollResult < ApplicationRecord
    has_many :summoner_match_group
    belongs_to :champion
    belongs_to :champion_spell

end
