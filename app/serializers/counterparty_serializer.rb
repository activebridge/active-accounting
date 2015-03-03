class CounterpartySerializer < ActiveModel::Serializer
  attributes :id, :name, :start_date, :active, :assigned, :monthly_payment, :value_payment, :successful_payment, :type

  def start_date
    object.start_date.strftime('%d-%m-%Y') if object.start_date
  end
end
