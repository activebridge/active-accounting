class ClientInfoSerializer < ActiveModel::Serializer
  attributes :id, :name, :agreement, :invoice_id, :address, :repr_name, :title_en, :title_ua
end
