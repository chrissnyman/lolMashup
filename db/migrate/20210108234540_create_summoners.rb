class CreateSummoners < ActiveRecord::Migration[6.0]
  def change
    create_table :summoners do |t|
      t.string :name
      t.string :profile_icon_id
      t.string :summoner_level
      t.string :region
      t.string :riot_id

      t.timestamps
    end
  end
end
