
require 'httparty'

module Riot
    class DataDragon
        
        def initialize(meta_version = nil)
            @meta_version = meta_version
        end

        def get_champions
            endpoint = "#{api_url}/champion.json"

            response = perform_call(endpoint,'get')

            response
        end

        private
            def current_meta_version
                @meta_version if @meta_version.present?
                '11.1.1' unless @meta_version.present?
            end
            
            def api_url
                "http://ddragon.leagueoflegends.com/cdn/#{current_meta_version}/data/en_US"
            end
            
            def perform_call(endpoint,call_type,get_data = {}, post_data = {})
                url_params = ""
                get_data.each do |key,val|
                    cur_url +=  "?" if url_params.blank?
                    cur_url +=  "&" if url_params.present?
                    cur_url +=  "#{key}=#{val}"
                end
                cur_url = "#{endpoint}#{url_params}"
                puts "perform_call #{call_type}: #{cur_url}"
    
                response = false
                if call_type.downcase == 'post'
                    response = HTTParty.post(cur_url,
                        :body => post_data.to_json,
                        :headers => { 
                            'Content-Type' => 'application/json',
                        }
                    )
                elsif call_type.downcase == 'get'
                    response = HTTParty.get(cur_url,
                        :headers => { 
                            'Content-Type' => 'application/json',
                        }
                    )
                end
    
                if response == false 
                    return false
                end
                if response.code == 200 or response.code == 201 or response.code == 204
                    return response.parsed_response
                else
                    puts 'Unexpected response ', response.code, response.message
                    return false
                end
            end
    end
end