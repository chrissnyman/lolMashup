class RollResult < ApplicationRecord
    belongs_to :summoner_match_group
    belongs_to :champion

end
