class InvoicesController < ApplicationController
  before_action :hours_by_month, only: :show
  before_action :find_customer, only: :show

  def show
    @invoice_number = invoice_number(@customer)
    @total_money = total_money(@customer, @hours)
    render pdf: "invoice_#{@customer.name + Time.current.strftime('%m-%d-%Y')}",
           template: 'invoices/show.pdf.slim',
           dpi: '600'
  end

  private

  def invoice_number(customer)
    start_date = customer.start_date
    invoice_date = params[:month].to_date
    number_of_months = 12
    ((invoice_date.year * number_of_months + invoice_date.month) - (start_date.year * number_of_months + start_date.month)) + 1
  end

  def total_money(customer, hours)
    hours.sum(:hours) * customer.value_payment if customer.value_payment
  end

  def hours_by_month
    @hours = Hour.by_customer(params[:id]).by_month(params[:month])
  end

  def find_customer
    @customer = Customer.find(params[:id])
  end
end
