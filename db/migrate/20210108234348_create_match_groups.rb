class CreateMatchGroups < ActiveRecord::Migration[6.0]
  def change
    create_table :match_groups do |t|
      t.string :uuid
      t.string :name
      t.string :region
      t.string :password
      t.string :mode
      t.integer :size

      t.timestamps
    end
  end
end
