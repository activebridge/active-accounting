class InvoicesController < ApplicationController
  before_action :find_customer, only: :show

  def show
    @invoice_number = invoice_calculator.invoice_number
    @total_money = invoice_calculator.total_money
    @hours = invoice_calculator.hours_by_month
    render pdf: "invoice_#{@customer.name + Time.current.strftime('%m-%d-%Y')}",
           template: 'invoices/show.pdf.slim',
           dpi: '600'
  end

  private

  def find_customer
    @customer = Customer.find(params[:id])
  end

  def invoice_calculator
    @invoice_calculator ||= InvoiceCalculator.new(@customer, params[:month])
  end
end
