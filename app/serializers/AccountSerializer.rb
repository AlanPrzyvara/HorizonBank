class AccountSerializer
  include JSONAPI::Serializer
  attributes :name, :birthdate, :document, :balance
end
