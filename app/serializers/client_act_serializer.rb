class ClientActSerializer < ActiveModel::Serializer
  attributes :id, :customer, :total_money, :month

  def month
    object.month.strftime('%m/%Y')
  end

  def customer
    object.customer
  end
end
