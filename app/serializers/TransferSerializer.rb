class TransferSerializer
  include JSONAPI::Serializer

  attributes :id, :transfer_type, :amount, :created_at

  attribute :sender_account do |transfer|
    {
      id: transfer.sender_account.id,
      name: transfer.sender_account.name
    }
  end

  attribute :receiver_account do |transfer|
    {
      id: transfer.receiver_account.id,
      name: transfer.receiver_account.name
    }
  end
end
