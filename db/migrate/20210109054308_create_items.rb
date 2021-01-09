class CreateItems < ActiveRecord::Migration[6.0]
  def change
    create_table :items do |t|
      t.string :name
      t.string :imagename
      t.string :rarity
      t.integer :depth

      t.string :image
      t.string :tags
      t.string :into
      t.string :from
      t.string :maps
      t.string :title
      t.string :gold

      t.timestamps
    end
  end
end
