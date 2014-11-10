class CounterpartySerializer < ActiveModel::Serializer
  attributes :id, :name, :start_date, :active, :assigned
end
