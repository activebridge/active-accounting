class ClientActSerializer < ActiveModel::Serializer
  attributes :id, :customer, :total_money, :month, :signature

  def month
    object.month.strftime('%m/%Y')
  end

  def customer
    object.customer
  end

  def signature
    object.signature.as_json(methods: :short_name_ua)
  end
end
