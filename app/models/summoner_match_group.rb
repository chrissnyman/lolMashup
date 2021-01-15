class SummonerMatchGroup < ApplicationRecord
    belongs_to :summoner
    belongs_to :match_group
    belongs_to :roll_result, optional: true
    belongs_to :lane_role, optional: true
    
    def roll_build(mirror_with_summoner_match_group = nil)
        
        is_jungler = false
        is_jungler = true if self.lane_role.name == "Jungle"

        champion = roll_champ(is_jungler,mirror_with_summoner_match_group)

        item_list = roll_item_build(is_jungler)

        champ_spell = roll_champ_spell(champion)
        
        summoner_spell_list = roll_summoner_spell_list(is_jungler)

        rune_page = RunePage.build_random_page

        roll_data = {
            champion_id: champion.id,
            item_build: item_list.join(','),
            summoner_spells: summoner_spell_list.join(','),
            champion_spell_id: champ_spell.id,
            rune_build: rune_page.stringify,
        }

        if self.roll_result.present? and not self.roll_result.frozen?
            self.roll_result.update(roll_data)
        else
            new_roll = RollResult.create!(roll_data)
            self.update(roll_result_id: new_roll.id)
        end
    end

    private

        def roll_champ(is_jungler = false, mirror_with_summoner_match_group = nil)
            champ_list = build_champ_list(self.summoner.summoner_champions,mirror_with_summoner_match_group.summoner.summoner_champions) if mirror_with_summoner_match_group.present?

            offset = rand(champ_list.count)
            summoner_champion = champ_list.offset(offset).first

            summoner_champion
        end

        def build_champ_list(champ_list,other_summoner_champions)
            free_champion_ids = ServerRegion.where(region_code: self.match_group.region).first.free_champion_ids.split(',')
            champ_ids = free_champion_ids + champ_list.pluck(:champion_id) + other_summoner_champions.pluck(:champion_id)
            
            Champion.where("id in (#{champ_ids.join(',')})")
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
