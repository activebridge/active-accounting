class CounterpartyRegisterSerializer < ActiveModel::Serializer
  attributes :name, :id, :value_payment, :type
end
