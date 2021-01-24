
require 'httparty'

module Riot
    class ApiClient
        
		def initialize
        end

        def get_summoner_data(region,summoner_name)
            endpoint = "https://#{api_url(region)}/lol/summoner/v4/summoners/by-name/#{summoner_name}"

            perform_call(endpoint,'get')
        end

        def get_summoner_champ_masteries(region,encryptedSummonerId)
            endpoint = "https://#{api_url(region)}/lol/champion-mastery/v4/champion-masteries/by-summoner/#{encryptedSummonerId}"

            perform_call(endpoint,'get')
        end

        def get_free_champion_rotation(region)
            endpoint = "https://#{api_url(region)}/lol/platform/v3/champion-rotations"

            perform_call(endpoint,'get')
        end
        
        def get_recent_matches(region,encryptedAccountId, beginTime)
            endpoint = "https://#{api_url(region)}/lol/match/v4/matchlists/by-account/#{encryptedAccountId}"

            perform_call(endpoint,'get', {beginTime: beginTime })
        end
        
        def get_match_details(region,matchId)
            endpoint = "https://#{api_url(region)}/lol/match/v4/matches/#{matchId}"

            perform_call(endpoint,'get')
        end

        def get_last_match_data(region,encryptedAccountId, beginTime)
            recent_matches = get_recent_matches(region,encryptedAccountId, beginTime)
            last_match_id = recent_matches["matches"].first["gameId"]
            latest_match = get_match_details(region,recent_matches["matches"].first["gameId"])

            latest_match
        end

        private
            def api_url_list
                {
                    'BR1'   =>  'br1.api.riotgames.com',
                    'EUN1'  =>  'eun1.api.riotgames.com',
                    'EUW1'  =>  'euw1.api.riotgames.com',
                    'JP1'   =>  'jp1.api.riotgames.com',
                    'KR'    =>  'kr.api.riotgames.com',
                    'LA1'   =>  'la1.api.riotgames.com',
                    'LA2'   =>  'la2.api.riotgames.com',
                    'NA1'   =>  'na1.api.riotgames.com',
                    'OC1'   =>  'oc1.api.riotgames.com',
                    'TR1'   =>  'tr1.api.riotgames.com',
                    'RU'    =>  'ru.api.riotgames.com',
                }
            end

            def api_url(region)
                api_url_list[region]
            end

            def perform_call(endpoint,call_type,get_data = {}, post_data = {})
                cur_url = "#{endpoint}"
                cur_url_params = ""

                get_data.each do |key,val|
                    cur_url_params +=  "&" unless cur_url_params.blank?
                    cur_url_params +=  "#{key}=#{val}"
                end
                cur_url = "#{endpoint}?#{cur_url_params}" unless cur_url_params.blank?

                puts "perform_call #{call_type}: #{cur_url}"

                response = false
                if call_type.downcase == 'post'
                    response = HTTParty.post(cur_url,
                        :body => post_data.to_json,
                        :headers => { 
                            'Content-Type' => 'application/json',
                            "X-Riot-Token": "RGAPI-cab3b995-08e5-481b-a25a-57e7c515466c"
                        }
                    )
                elsif call_type.downcase == 'get'
                    response = HTTParty.get(cur_url,
                        :headers => { 
                            'Content-Type' => 'application/json',
                            "X-Riot-Token": "RGAPI-cab3b995-08e5-481b-a25a-57e7c515466c"
                        }
                    )
                end

                if response == false 
                    return false
                end
                if response.code == 200 or response.code == 201 or response.code == 204
                    return response.parsed_response
                else
                    puts "Unexpected response, code: #{response.code}, message #{response.message}"
                    return false
                end
            end
    end
end