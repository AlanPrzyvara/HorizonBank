class TransactionSerializer
  include JSONAPI::Serializer
  attributes :transaction_type, :amount, :balance_before, :balance_after, :created_at
end
