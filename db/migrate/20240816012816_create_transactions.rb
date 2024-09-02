class CreateTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :transactions do |t|
      t.references :account, null: false, foreign_key: true
      t.string :transaction_type
      t.decimal :amount
      t.decimal :balance_before
      t.decimal :balance_after

      t.timestamps
    end
  end
end
