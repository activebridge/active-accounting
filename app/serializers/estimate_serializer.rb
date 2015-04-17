class EstimateSerializer < ActiveModel::Serializer
  attributes :id, :customer, :hours, :month, :vendor

  def customers
    CustomerSerializer.new(object)
  end

  def month
    object.month.strftime("%m-%Y") if object.month
  end
end
