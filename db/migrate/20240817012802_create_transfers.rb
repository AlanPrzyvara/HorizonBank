class CreateTransfers < ActiveRecord::Migration[7.0]
  def change
    create_table :transfers do |t|
      t.references :sender_account, null: false, foreign_key: { to_table: :accounts }
      t.references :receiver_account, null: false, foreign_key: { to_table: :accounts }
      t.decimal :amount, null: false, precision: 15, scale: 2
      t.string :transfer_type, null: false, default: 'transfer'

      t.timestamps
    end
  end
end
