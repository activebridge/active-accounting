class CounterpartySerializer < ActiveModel::Serializer
  attributes :id, :name, :start_date, :active, :assigned, :monthly_payment, :value_payment, :payment_histories,
  :successful_payment, :type, :customer, :email, :client_info, :vendor_info, :signed_in, :currency_monthly_payment, :vacations_info

  def start_date
    object.start_date.strftime('%d-%m-%Y') if object.start_date
  end

  def customer
    object.customer_id? ? CustomerSerializer.new(object.customer) : { name: '', id: '' }
  end

  def client_info
    ClientInfoSerializer.new(object.client_info) if object.customer? && object.client_info
  end

  def vendor_info
    VendorInfoSerializer.new(object.vendor_info) if object.vendor? && object.vendor_info
  end

  def payment_histories
    payment_histories = []
    object.payment_histories.map do |h|
      payment_histories << {
        created_at: h.created_at.strftime('%d-%m-%Y'),
        updated_by: Admin.find_by(id: h.admin_id).email,
        value_payment: h.value_payment
      }
    end
    payment_histories
  end

  def vacations_info
    return unless object.type == Counterparty::TYPES::VENDOR
    vacations = object.vacations
    vacations_count = vacations.count
    days_used = vacations.map(&:start).select { |date| date < Time.now }.count
    days_reserved = vacations_count - days_used
    days_left = Vacation::DAYS - vacations_count
    vacation_info_params(days_used, days_reserved, days_left)
  end

  private

  def vacation_info_params(*args)
    {
      days_used: args[0],
      days_reserved: args[1],
      days_left: args[2]
    }
  end
end
