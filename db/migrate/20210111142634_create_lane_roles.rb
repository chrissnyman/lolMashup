class CreateLaneRoles < ActiveRecord::Migration[6.0]
  def change
    create_table :lane_roles do |t|
      t.string :name
      t.timestamps
    end

    add_column :roll_results, :lane_role_id, :integer

  end
end
