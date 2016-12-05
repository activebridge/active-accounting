class HourSerializer < ActiveModel::Serializer
  attributes :id, :customer, :hours, :month, :vendor

  def customer
    CustomerSerializer.new(object.customer)
  end

  def month
    object.month&.strftime('%m-%Y')
  end

  def vendor
    object.vendor_name
  end
end
