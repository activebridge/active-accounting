class VendorActSerializer < ActiveModel::Serializer
  attributes :id, :vendor, :total_money, :month

  def month
    object.month.strftime('%m/%Y')
  end

  def vendor
    object.vendor
  end
end
