class CounterpartySerializer < ActiveModel::Serializer
  attributes :id, :name, :start_date, :active, :assigned

  def start_date
    object.start_date.strftime('%d-%m-%Y') if object.start_date
  end
end
