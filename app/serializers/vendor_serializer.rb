class VendorSerializer < ActiveModel::Serializer
  attributes :name, :id, :customer_id, :approve_hours, :email, :auth_token
end
