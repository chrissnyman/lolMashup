class RuneSlot < ApplicationRecord
    belongs_to :rune_tree
    has_many :runes
end
