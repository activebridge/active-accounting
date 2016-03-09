class VendorSerializer < ActiveModel::Serializer
  attributes :name, :id, :customer_id, :approve_hours, :email, :start_date, :type, :auth_token
end
