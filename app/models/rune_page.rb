class RunePage
    attr_accessor :rune_page

    def stringify
        string_obj = ""
        string_obj += "#{self.rune_page[:primary][:rune_tree].id}-#{self.rune_page[:primary][:runes].join(',')}"
        string_obj += "|"
        string_obj += "#{self.rune_page[:secondary][:rune_tree].id}-#{self.rune_page[:secondary][:runes].join(',')}"
        string_obj += "|"
        string_obj += "#{self.rune_page[:stat_mods].join(',')}"

        string_obj
    end
    
    def self.build_random_page
        random_page = RunePage.new
        
        rune_tree_list = RuneTree.all
        primary_offset = rand(rune_tree_list.count)
        primary_rune_tree = rune_tree_list.offset(primary_offset).first
        secondary_offset = rand(rune_tree_list.count)
        while secondary_offset == primary_offset do
            secondary_offset = rand(rune_tree_list.count)
        end
        secondary_rune_tree = rune_tree_list.offset(secondary_offset).first

        rune_build = {
            primary: {
                rune_tree: primary_rune_tree,
                runes: []
            },
            secondary: {
                rune_tree: secondary_rune_tree,
                runes: []
            },
            stat_mods: []
        } 

        primary_rune_tree.rune_slots.each do |primary_slot|
            offset = rand(primary_slot.runes.count)
            rune_build[:primary][:runes] << primary_slot.runes.offset(offset).first.id
        end

        secondary_slot_offset_a = rand(secondary_rune_tree.rune_slots.count-1) + 1
        secondary_slot_a = secondary_rune_tree.rune_slots.offset(secondary_slot_offset_a).first
        secondary_slot_offset_b = rand(secondary_rune_tree.rune_slots.count)
        while secondary_slot_offset_b == secondary_slot_offset_a do
            secondary_slot_offset_b = rand(secondary_rune_tree.rune_slots.count)
        end
        secondary_slot_b = secondary_rune_tree.rune_slots.offset(secondary_slot_offset_b).first

        offset = rand(secondary_slot_a.runes.count)
        rune_build[:secondary][:runes] << secondary_slot_a.runes.offset(offset).first.id
        offset = rand(secondary_slot_b.runes.count)
        rune_build[:secondary][:runes] << secondary_slot_b.runes.offset(offset).first.id

        rune_build[:stat_mods] << self.get_random_stat_mod(1)
        rune_build[:stat_mods] << self.get_random_stat_mod(2)
        rune_build[:stat_mods] << self.get_random_stat_mod(3)

        random_page.rune_page = rune_build
        random_page
    end

    def self.get_random_stat_mod(slot_num)
        stat_mods = StatMod.where("allowed_in_slot like '%#{slot_num}%'")
        offset = rand(stat_mods.count)
        
        stat_mods.offset(offset).first.id
    end

    def self.from_string(string_obj)
        dats_me = RunePage.new

        rune_build = {
            primary: {
                rune_tree: nil,
                runes: []
            },
            secondary: {
                rune_tree: nil,
                runes: []
            },
            stat_mods: []
        }

        build_parts = string_obj.split('|')
        primary_parts = build_parts[0].split('-')
        rune_build[:primary][:rune_tree] = RuneTree.find(primary_parts[0])
        primary_parts[1].split(',').each do |rune_id|
            rune_build[:primary][:runes] << Rune.find(rune_id)
        end

        secondary_parts = build_parts[1].split('-')
        rune_build[:secondary][:rune_tree] = RuneTree.find(secondary_parts[0])
        secondary_parts[1].split(',').each do |rune_id|
            rune_build[:secondary][:runes] << Rune.find(rune_id)
        end
        
        stat_mods = build_parts[2].split(',')
        stat_mods.each do |stat_mod_id|
            rune_build[:stat_mods] << StatMod.find(stat_mod_id)
        end
        
        dats_me.rune_page = rune_build
        dats_me
    end
end

