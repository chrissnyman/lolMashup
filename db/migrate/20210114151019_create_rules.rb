class CreateRules < ActiveRecord::Migration[6.0]
  def change
    create_table :rules do |t|
      t.string :name 
      t.string :check_val
      t.string :check_calc
      t.boolean :required
  
      t.timestamps
    end
  end
end
