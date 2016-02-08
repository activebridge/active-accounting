class CounterpartySerializer < ActiveModel::Serializer
  attributes :id, :name, :start_date, :active, :assigned, :monthly_payment, :value_payment, :versions,
             :successful_payment, :type, :customer, :email, :client_info, :vendor_info, :signed_in, :currency_monthly_payment

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

  def versions
    versions = []
    object.versions.map do |v|
      versions << {
        created_at: v.created_at.strftime('%d-%m-%Y'),
        updated_by: Admin.find_by(id: v.whodunnit).try(:email),
        value_payment: v.reify.try(:value_payment)
      }
    end
    versions
  end
end
