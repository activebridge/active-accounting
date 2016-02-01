class ClientInvoiceSerializer < ActiveModel::Serializer
  attributes :id, :customer, :month, :first_day_month

  def month
    object.month.strftime('%m/%Y')
  end

  def first_day_month
    object.month.strftime('%d.%m.%Y')
  end

  def customer
    object.customer
  end
end
