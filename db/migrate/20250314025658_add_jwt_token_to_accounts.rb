class AddJwtTokenToAccounts < ActiveRecord::Migration[7.1]
  def change
    add_column :accounts, :jwt_token, :string
  end
end
