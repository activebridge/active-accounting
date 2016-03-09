class CustomerSerializer < ActiveModel::Serializer
  attributes :name, :id, :start_date, :type
end
