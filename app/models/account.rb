class Account < ApplicationRecord
  has_many :transactions
  has_many :sent_transfers, class_name: 'Transfer', foreign_key: 'sender_account_id'
  has_many :received_transfers, class_name: 'Transfer', foreign_key: 'receiver_account_id'

  validates :name, :birthdate, :document, presence: true


  # Garantir que o saldo inicial seja zero ao criar uma conta
  after_initialize :set_default_balance, if: :new_record?

  private

  def set_default_balance
    self.balance ||= 0.0
  end
end
