class AddButtonBindingToChampionSpells < ActiveRecord::Migration[6.0]
  def change
    add_column :champion_spells, :button_binding, :string
  end
end
