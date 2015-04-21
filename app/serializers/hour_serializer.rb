class HourSerializer < ActiveModel::Serializer
  attributes :id, :customer, :hours, :month, :vendor

  def customer
    object.customer_name
  end

  def month
    object.month.strftime("%m-%Y") if object.month
  end

  def vendor
    object.vendor_name
  end
end
