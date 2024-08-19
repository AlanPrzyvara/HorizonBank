class Addpassword1 < ActiveRecord::Migration[7.1]
  def change
    add_column :accounts, :password, :string
  end
end
