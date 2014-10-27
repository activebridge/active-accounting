class CounterpartyReportItemSerializer < ActiveModel::Serializer
  attributes :name, :value

  def name
    object.counterparty.try(:name)
  end

  def value
    object.sum
  end
end
