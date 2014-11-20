class CounterpartyReportItemSerializer < ActiveModel::Serializer
  attributes :name, :values

  def name
    Counterparty.where(id: object[0]).first.name
  end

  def values
    object[1]
  end
end
