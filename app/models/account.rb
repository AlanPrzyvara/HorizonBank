class Account < ApplicationRecord
  has_many :transactions

  validates :name, :birthdate, :document, presence: true

  # Garantir que o saldo inicial seja zero ao criar uma conta
  after_initialize :set_default_balance, if: :new_record?

  private

  def set_default_balance
    self.balance ||= 0.0
  end
end
