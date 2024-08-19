class RenamePasswordToPasswordDigestInAccounts < ActiveRecord::Migration[7.1]
  def change
    rename_column :accounts, :password, :password_digest
  end
end
