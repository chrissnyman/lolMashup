class Champion < ApplicationRecord
    has_many :summoner_champions
    has_many :roll_results
end
