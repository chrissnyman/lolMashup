class AddAccountIdToSummoners < ActiveRecord::Migration[6.0]
  def change
    add_column :summoners, :riot_account_id, :string
  end
end
