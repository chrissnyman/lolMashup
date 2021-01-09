class SummonerMatchGroup < ApplicationRecord
    belongs_to :summoner
    belongs_to :match_group
    has_one :roll_result

    def roll_build
        puts ""
        puts "Rolling for #{self.summoner.name}"
        puts ""

        offset = rand(self.summoner.summoner_champions.count)
        summoner_champion = self.summoner.summoner_champions.offset(offset).first
        puts "got champ #{summoner_champion.champion.name}"

        roll_data = {
            summoner_match_group_id: self.id,
            champion_id: summoner_champion.champion.id,
        }

        if self.roll_result.present?
            self.roll_result.update(roll_data)
        else
            RollResult.create!(roll_data)
        end
    end
end
