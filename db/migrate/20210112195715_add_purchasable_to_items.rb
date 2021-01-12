class AddPurchasableToItems < ActiveRecord::Migration[6.0]
  def change
    add_column :items, :purchasable, :string
  end
end
