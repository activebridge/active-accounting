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
    updated_by = nil
    object.versions.map do |v|
      versions << {
        created_at: v.created_at.strftime('%d-%m-%Y'),
        updated_by: Admin.find_by(id: v.whodunnit).try(:email),
        value_payment: v.reify.value_payment
      } if v.reify.try(:value_payment)
      updated_by = Admin.find_by(id: v.whodunnit).try(:email)
    end
    versions << current_payment
    versions
  end

  private

  def current_payment
    {
      created_at: object.updated_at.strftime('%d-%m-%Y'),
      updated_by: Admin.find_by(id: object.versions.last.whodunnit).try(:email),
      value_payment: object.value_payment
    } if object.value_payment
  end
end
