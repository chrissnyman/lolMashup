class CreateRuneTrees < ActiveRecord::Migration[6.0]
  def change
    create_table :rune_trees do |t|
      t.string :icon
      t.string :key
      t.string :name

      t.timestamps
    end
  end
end
