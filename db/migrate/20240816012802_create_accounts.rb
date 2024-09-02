class CreateAccounts < ActiveRecord::Migration[7.1]
  def change
    create_table :accounts do |t|
      t.string :name
      t.date :birthdate
      t.string :document
      t.decimal :balance

      t.timestamps
    end
  end
end
