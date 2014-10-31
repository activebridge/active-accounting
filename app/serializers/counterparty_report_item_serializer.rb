class CounterpartyReportItemSerializer < ActiveModel::Serializer
  attributes :name, :value

  def name
    object.counterparty.try(:name)
  end

  def value
    object.sum.round(2)
  end
end
