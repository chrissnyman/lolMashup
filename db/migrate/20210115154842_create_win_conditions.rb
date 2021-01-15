class CreateWinConditions < ActiveRecord::Migration[6.0]
  def change
    create_table :win_conditions do |t|
      t.string :title
      t.string :description
      t.string :condition_metric
      t.string :metric_calc_type

      t.timestamps
    end
  end
end
