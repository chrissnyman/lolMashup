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
        while item_list.count < 6
            offset = rand(remaining_item_list.count)
            next_item_id = remaining_item_list.offset(offset).first.id
            next if item_list.include? next_item_id
            item_list << next_item_id
        end
        item_list.shuffle!

        champ_spell_list = summoner_champion.champion.champion_spells
        offset = rand(champ_spell_list.count)
        champ_spell = champ_spell_list.offset(offset).first

        summoner_spell_list = []
        summ_spell_list = SummonerSpell.all
        while summoner_spell_list.count < 2
            offset = rand(summ_spell_list.count)
            spell = summ_spell_list.offset(offset).first
            next if summoner_spell_list.include? spell.id
            next if spell.name == "Smite" 
            summoner_spell_list << spell.id
        end

        rune_page = RunePage.build_random_page

        roll_data = {
            summoner_match_group_id: self.id,
            champion_id: summoner_champion.champion.id,
            item_build: item_list.join(','),
            summoner_spells: summoner_spell_list.join(','),
            champion_spell_id: champ_spell.id,
            rune_build: rune_page.stringify,
        }

        if self.roll_result.present?
            self.roll_result.update(roll_data)
        else
            RollResult.create!(roll_data)
        end
    end
end
