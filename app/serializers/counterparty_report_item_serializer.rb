class CounterpartyReportItemSerializer < ActiveModel::Serializer
  attributes :name, :value, :date

  def name
    object.counterparty.try(:name)
  end

  def value
    object.sum.round(2)
  end

  def date
    object.try(:date)
  end
end
