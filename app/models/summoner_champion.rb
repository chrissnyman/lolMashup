class SummonerChampion < ApplicationRecord
    belongs_to :summoner
    belongs_to :champion
end
