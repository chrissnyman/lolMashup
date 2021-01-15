class ChangeItemGoldToInteger < ActiveRecord::Migration[6.0]
  def change
    remove_column :items, :gold, :string
    add_column :items, :gold, :integer
  end
end
