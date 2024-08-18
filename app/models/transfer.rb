class Transfer < ApplicationRecord
  belongs_to :sender_account, class_name: 'Account'
  belongs_to :receiver_account, class_name: 'Account'

  validates :amount, numericality: { greater_than: 0 }
end
