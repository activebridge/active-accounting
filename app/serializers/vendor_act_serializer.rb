class VendorActSerializer < ActiveModel::Serializer
  attributes :id, :vendor, :total_money, :month, :signature

  def month
    object.month.strftime('%m/%Y')
  end

  def vendor
    object.vendor
  end

  def signature
    object.signature.as_json(methods: :short_name_ua)
  end
end
