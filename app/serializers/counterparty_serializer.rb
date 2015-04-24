class CounterpartySerializer < ActiveModel::Serializer
  attributes :id, :name, :start_date, :active, :assigned, :monthly_payment, :value_payment, :successful_payment, :type, :customer, :email, :client_info

  def start_date
    object.start_date.strftime('%d-%m-%Y') if object.start_date
  end

  def customer
    object.customer_id? ? CustomerSerializer.new(object.customer) : { name: '', id: '' }
  end

  def client_info
    ClientInfoSerializer.new(object.client_info) if object.customer? && object.client_info
  end
end
