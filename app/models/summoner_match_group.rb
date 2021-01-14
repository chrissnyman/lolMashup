class SummonerMatchGroup < ApplicationRecord
    belongs_to :summoner
    belongs_to :match_group
    has_one :roll_result
    belongs_to :lane_role, optional: true
    
    def roll_build
        
        is_jungler = false
        is_jungler = true if self.lane_role.name == "Jungle"

        summoner_champion = roll_champ(is_jungler)

        item_list = roll_item_build(is_jungler)

        champ_spell = roll_champ_spell(summoner_champion.champion)
        
        summoner_spell_list = roll_summoner_spell_list(is_jungler)

        rune_page = RunePage.build_random_page

        roll_data = {
            summoner_match_group_id: self.id,
            champion_id: summoner_champion.champion.id,
            item_build: item_list.join(','),
            summoner_spells: summoner_spell_list.join(','),
            champion_spell_id: champ_spell.id,
            rune_build: rune_page.stringify,
        }

        if self.roll_result.present? and not self.roll_result.frozen?
            self.roll_result.update(roll_data)
        else
            RollResult.create!(roll_data)
        end
    end

    private 

        def roll_champ(is_jungler = false)
            offset = rand(self.summoner.summoner_champions.count)

            summoner_champion = self.summoner.summoner_champions.offset(offset).first

            summoner_champion
        end

        def roll_champ_spell(champ)
            champ_spell_list = champ.champion_spells.where.not(button_binding: 'R')
            offset = rand(champ_spell_list.count)
            champ_spell = champ_spell_list.offset(offset).first
        end

        def roll_item_build(is_jungler = false)
            item_limit = 6
            item_list = []
    
            boot_list = Item.where("tags like '%\"Boots\"%' and depth > 1")
            offset = rand(boot_list.count)
            boots = boot_list.offset(offset).first
    
            mythic_list = Item.where(rarity: 'Mythic')
            offset = rand(mythic_list.count)
            mythic = mythic_list.offset(offset).first
    
            item_list << boots.id
            item_list << mythic.id
    
            remaining_item_list = Item.where("depth > 2 and rarity != 'Mythic'")
            while item_list.count < item_limit
                offset = rand(remaining_item_list.count)
                next_item_id = remaining_item_list.offset(offset).first.id
                next if item_list.include? next_item_id
                item_list << next_item_id
            end
            item_list.shuffle!

            if is_jungler
                jungle_item_list = Item.where(tags: '["LifeSteal", "SpellVamp", "Jungle"]')
                offset = rand(jungle_item_list.count)
                jungle_item_id = jungle_item_list.offset(offset).first.id

                item_list.unshift(jungle_item_id)
            else
                starting_item_list = Item.where("tags like '%\"Lane\"%' and tags not like '%\"Vision\"%'").where(purchasable: true)
                offset = rand(starting_item_list.count)
                starting_item_id = starting_item_list.offset(offset).first.id

                item_list.unshift(starting_item_id)
            end

            item_list
        end

        def roll_summoner_spell_list(is_jungler = false)
            summoner_spell_list = []
            summ_spell_list = SummonerSpell.all
            if is_jungler
                summoner_spell_list << SummonerSpell.where(name: 'Smite').first.id

            end
            while summoner_spell_list.count < 2
                offset = rand(summ_spell_list.count)
                spell = summ_spell_list.offset(offset).first
                next if summoner_spell_list.include? spell.id
                next if spell.name == "Smite" 
                summoner_spell_list << spell.id
            end

            summoner_spell_list
        end
end
