class CounterpartySerializer < ActiveModel::Serializer
  attributes :id, :name, :start_date, :active, :employment

  def employment
    true if Register.where(counterparty_id: id) != []
  end

end
