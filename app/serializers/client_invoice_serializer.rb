class ClientInvoiceSerializer < ActiveModel::Serializer
  attributes :id, :customer, :month, :first_day_month, :signature

  def month
    object.month.strftime('%m/%Y')
  end

  def first_day_month
    object.month.strftime('%d.%m.%Y')
  end

  def customer
    object.customer
  end

  def signature
    object.signature.as_json(methods: :short_name_ua)
  end
end
