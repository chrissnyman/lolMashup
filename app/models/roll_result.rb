class RollResult < ApplicationRecord
    belongs_to :summoner_match_group
    belongs_to :champion
    belongs_to :champion_spell

end
