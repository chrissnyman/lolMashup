class CreateChampions < ActiveRecord::Migration[6.0]
  def change
    create_table :champions do |t|
      t.string :champion_id
      t.string :name
      t.string :imagename
      t.string :image
      t.string :info
      t.string :partype
      t.string :tags
      t.string :title
      t.string :stats
    end
  end
end
