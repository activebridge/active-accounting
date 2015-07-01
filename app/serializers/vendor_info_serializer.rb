class VendorInfoSerializer < ActiveModel::Serializer
  attributes :id, :name, :ipn, :contract, :address, :account, :bank, :mfo, :short_name
end
