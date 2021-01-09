class ChampionSpell < ApplicationRecord
    has_many :roll_results
    belongs_to :champion
end
