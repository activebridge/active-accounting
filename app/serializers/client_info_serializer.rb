class ClientInfoSerializer < ActiveModel::Serializer
  attributes :id, :name, :agreement, :invoice_id, :address, :repr_name
end
