
require 'httparty'

module Riot
    class DataDragon
        
        def initialize(meta_version = nil)
            @meta_version = meta_version
        end

        def refresh_champion_list
            champions_data = get_champions

            champions_data["data"].each do |champ_name,champ_data|

                champ_obj = {
                  id: champ_data["key"].to_i,
                  champion_id: champ_data["id"],
                  name: champ_data["name"],
                  imagename: champ_data["image"]["full"],
                  image: champ_data["image"],
                  info: champ_data["info"],
                  partype: champ_data["partype"],
                  tags: champ_data["tags"],
                  title: champ_data["title"],
                  stats: champ_data["stats"],
                }
                if Champion.where(id: champ_obj[:id]).count == 1
                  Champion.find(champ_obj[:id]).update(champ_obj)
                #   puts "updating #{champ_obj[:name]}"
                else
                #   puts "creating #{champ_obj[:name]}"
                  Champion.create(champ_obj)
                end

                refresh_champion_spells(Champion.find(champ_obj[:id]))
            end
        end

        def refresh_champion_spells(champ)
            button_bindings = ['Q','W','E','R']
            # puts "refresh_champion_spells: #{champ}"
            champ_details = get_champion_details(champ.champion_id)
            # passive = champ_details["data"][0]["passive"]
            spells = champ_details["data"][champ.champion_id]["spells"]
            spells.each_with_index do |spell_data, index|
                spell_obj = {
                  spell_id: spell_data["id"],
                  champion_id: champ.id,
                  name: spell_data["name"],
                  button_binding: button_bindings[index],
                  imagename: spell_data["image"]["full"],
                }
                if ChampionSpell.where(champion_id: spell_obj[:champion_id], spell_id: spell_obj[:spell_id]).count == 1
                    ChampionSpell.where(champion_id: spell_obj[:champion_id], spell_id: spell_obj[:spell_id]).first.update(spell_obj)
                    # puts "updating #{spell_obj[:name]}"
                else
                    # puts "creating #{spell_obj[:name]}"
                    ChampionSpell.create(spell_obj)
                end
            end
        end
        
        def refresh_item_list
            item_list = get_items

            item_list["data"].each do |item_id,item_data|
                next unless item_data["maps"]['11'] == true #Summoners rift only

                item_rarity = ''
                item_rarity = 'Legendary' if item_data["description"].include? 'rarityLegendary'
                item_rarity = 'Mythic' if item_data["description"].include? 'rarityMythic'
                
                item_obj = {
                    id: item_id.to_i,
                    name: item_data["name"],
                    depth: item_data["depth"],
                    imagename: item_data["image"]["full"],
                    rarity: item_rarity,
                    image: item_data["image"],
                    tags: item_data["tags"],
                    into: item_data["into"],
                    from: item_data["from"],
                    # maps: item_data["maps"],
                    # title: item_data["title"],
                    gold: item_data["gold"]["base"],
                    purchasable: item_data["gold"]["purchasable"],
                }
                if Item.where(id: item_obj[:id]).count == 1
                  Item.find(item_obj[:id]).update(item_obj)
                #   puts "updating #{item_obj[:name]}"
                else
                  Item.create(item_obj)
                #   puts "creating #{item_obj[:name]}"
                end
            end
        end

        def refresh_summoner_spell_list
            # puts "refresh_champion_spells"
            spell_list = get_summoner_spell_list
            spells = spell_list["data"]
            spells.each do |spell_id,spell_data|
                next unless spell_data["modes"].include? "CLASSIC"
                spell_obj = {
                  spell_id: spell_data["id"],
                  name: spell_data["name"],
                  imagename: spell_data["image"]["full"],
                  modes: spell_data["modes"],
                }
                if SummonerSpell.where(spell_id: spell_obj[:spell_id]).count == 1
                    SummonerSpell.where(spell_id: spell_obj[:spell_id]).first.update(spell_obj)
                    puts "updating #{spell_obj[:name]}"
                else
                    puts "creating #{spell_obj[:name]}"
                    SummonerSpell.create(spell_obj)
                end
            end
        end

        def refresh_rune_list
            rune_list = get_rune_list

            rune_list.each do |rune_tree|
                # puts "#{rune_tree["name"]}"
                rune_tree_obj = {
                  icon: rune_tree["icon"],
                  key: rune_tree["key"],
                  name: rune_tree["name"],
                }
                cur_rune_tree = RuneTree.where(name: rune_tree["name"]).first
                if cur_rune_tree.present?
                    cur_rune_tree.update(rune_tree_obj)
                else
                    RuneTree.create!(rune_tree_obj)
                    cur_rune_tree = RuneTree.where(name: rune_tree["name"]).first
                end
                
                rune_tree["slots"].each_with_index do |rune_slot,index|
                    rune_slot_obj = {
                      rune_tree_id: cur_rune_tree.id,
                      slot_index: index,
                    }
                    cur_rune_slot = RuneSlot.where(rune_slot_obj).first
                    unless cur_rune_slot.present?
                        RuneSlot.create!(rune_slot_obj)
                        cur_rune_slot = RuneSlot.where(rune_slot_obj).first
                    end
                    
                    rune_slot["runes"].each do |rune|
                        # puts " #{index} - #{rune["name"]}"
                        rune_obj = {
                            rune_slot_id: cur_rune_slot.id,
                            icon: rune["icon"],
                            key: rune["key"],
                            name: rune["name"],
                        }

                        cur_rune = Rune.where(rune_slot_id: cur_rune_slot.id, name: rune["name"]).first
                        if cur_rune.present?
                            cur_rune.update(rune_obj)
                        else
                            Rune.create!(rune_obj)
                            # cur_rune = Rune.where(name: rune["name"]).first
                        end
                    end
                end
                puts "------------------"
            end
        end

        private
            def current_meta_version
                @meta_version if @meta_version.present?
                '11.1.1' unless @meta_version.present?
            end
            
            def api_url
                "http://ddragon.leagueoflegends.com/cdn/#{current_meta_version}/data/en_US"
            end

            def get_champions
                perform_call("#{api_url}/champion.json",'get')
            end

            def get_champion_details(champion_id)
                perform_call("#{api_url}/champion/#{champion_id}.json",'get')
            end

            def get_items
                perform_call("#{api_url}/item.json",'get')
            end

            def get_summoner_spell_list
                perform_call("#{api_url}/summoner.json",'get')
            end

            def get_rune_list
                perform_call("#{api_url}/runesReforged.json",'get')
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