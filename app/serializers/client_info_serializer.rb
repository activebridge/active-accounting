class ClientInfoSerializer < ActiveModel::Serializer
  attributes :id, :name, :agreement_number, :invoice_id, :address, :repr_name, :title_en, :title_ua, :agreement_date
end
