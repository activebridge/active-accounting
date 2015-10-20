class InvoiceSerializer < ActiveModel::Serializer
  attributes :id, :customer, :hours_sum, :month, :money, :value_payment

  def month
    object.month.strftime('%m/%Y')
  end

  def hours_sum
    hours.inject(:+)
  end

  def value_payment
    hours.length * object.customer.value_payment
  end

  def customer
    object.customer
  end

  def money
    invoice_calculator = InvoiceCalculator.new(object.customer, month)
    invoice_calculator.total_money
  end

  private

  def hours
    total_hours = []
    object.customer.vendors.each do |vendor|
      total_hours += vendor.all_hours(object.month)
    end
    total_hours
  end
end
