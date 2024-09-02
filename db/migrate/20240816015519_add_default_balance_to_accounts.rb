class AddDefaultBalanceToAccounts < ActiveRecord::Migration[7.1]
  def change
    change_column_default :accounts, :balance, 0.0
  end
end
