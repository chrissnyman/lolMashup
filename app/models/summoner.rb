class Summoner < ApplicationRecord
    has_many :summoner_match_groups
    has_many :summoner_matches, :through => :summoner_match_groups
    has_many :summoner_champions
    has_many :champions, :through => :summoner_champions

    attr_accessor :failed_to_reload

    def self.load_summoner(region, summoner_name)
        summoner = Summoner.where(name:summoner_name, region: region).first
        unless summoner.present? and summoner.updated_at > Time.now - 24.hour
            fresh_summoner_data = ::Riot::ApiClient.new.get_summoner_data(region,summoner_name)
            if fresh_summoner_data != false
                summoner = self.save_summoner(region, fresh_summoner_data) if fresh_summoner_data.present?
                summoner.load_champion_masteries
            else
                summoner.failed_to_reload = true if summoner.present?
            end
        end
        summoner
    end

    def load_champion_masteries
        summoner_champ_masteries_data = ::Riot::ApiClient.new.get_summoner_champ_masteries(self.region,self.riot_id)

        summoner_champ_masteries_data.each do |cur_champ_data|
            champ = Champion.find(cur_champ_data["championId"])
            champ_mastery = {
                summoner_id: self.id,
                champion_id: champ.id,
                mastery_level: cur_champ_data["championLevel"],
                last_play_time: Time.at(cur_champ_data["lastPlayTime"]/1000),
                champion_points_since_last: cur_champ_data["championPointsSinceLastLevel"],
                champion_points_to_next: cur_champ_data["championPointsUntilNextLevel"],
                chest_granted: cur_champ_data["chestGranted"],
                tokens_earned: cur_champ_data["tokensEarned"],
                champion_points: cur_champ_data["championPoints"],
            }

            existing_record = SummonerChampion.where({summoner_id: self.id, champion_id: champ.id}).first
            if existing_record.present?
                existing_record.update(champ_mastery)
            else
                SummonerChampion.create(champ_mastery)
            end
        end
    end
    
    private
        def self.save_summoner(region, summoner_data)
            summoner_obj = {
                name: summoner_data["name"],
                profile_icon_id: summoner_data["profileIconId"],
                summoner_level: summoner_data["summonerLevel"],
                region: region,
                riot_id: summoner_data["id"],
                riot_account_id: summoner_data["accountId"],
            }

            existing_summoner = Summoner.where(name:summoner_obj[:name], region: summoner_obj[:region]).first
            if existing_summoner.present?
                existing_summoner.update(summoner_obj)
            else
                existing_summoner = Summoner.create(summoner_obj)
            end

            existing_summoner
        end
end
