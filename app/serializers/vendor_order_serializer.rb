class VendorOrderSerializer < ActiveModel::Serializer
  attributes :id, :vendor, :features, :month, :first_day_month, :signature

  def month
    object.month.strftime('%m/%Y')
  end

  def first_day_month
    object.month.strftime('%d.%m.%Y')
  end

  def vendor
    object.vendor
  end

  def signature
    object.signature.as_json(methods: :short_name_ua)
  end

  def features
    ActiveModel::ArraySerializer.new(object.features,
                                     each_serializer: FeatureSerializer,
                                     root: nil)
  end
end
