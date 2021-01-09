class Champion < ApplicationRecord
    has_many :summoner_champions
    has_many :roll_results
    has_many :champion_spells
end
