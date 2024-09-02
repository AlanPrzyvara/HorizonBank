class Transaction < ApplicationRecord
  belongs_to :account

  enum transaction_type: { debit: 'debit', credit: 'credit' }

  validates :transaction_type, :amount, :balance_before, :balance_after, presence: true

end
