class InvoiceCalculator
  MONTH_COUNT = 12

  def initialize(customer, month)
    @customer = customer
    @invoice_date = month.to_date
  end

  def total_money
    @total_money ||= hours_by_month.sum(:hours) * @customer.value_payment if @customer.value_payment
  end

  def hours_by_month
    @hours_by_month ||= @customer.hours.by_month(@invoice_date)
  end

  def invoice_number
    @invoice_number ||= begin
      ((@invoice_date.year *  MONTH_COUNT + @invoice_date.month) - ( @customer.start_date.year *  MONTH_COUNT +  @customer.start_date.month)) + 1
    end
  end
end
