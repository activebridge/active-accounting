class InvoicesController < ApplicationController
  before_action :find_invoice, only: [:show, :update]
  before_action :find_customer

  def index
    invoices = ActiveModel::ArraySerializer.new(@customer.client_invoices.order('id desc'),
                                            each_serializer: ClientInvoiceSerializer,
                                            root: nil)
    render json: invoices, status: 200
  end

  def create
    if invoice_calculator.hours_by_month.empty? || info_empty.present?
      messages = invoice_calculator.hours_by_month.empty? ? ['no_hours'] : info_empty
      render json: { status: :error, messages: messages }, status: 422
    else
      invoice = ClientInvoice.new(invoice_params)
      if invoice.save
        render json: ClientInvoiceSerializer.new(invoice), status: 200
      else
        render json: { status: :error, messages:  invoice.errors.messages[:month] }, status: 422
      end
    end
  end

  def show
    @invoice_number = invoice_calculator.invoice_number
    @total_money = invoice_calculator.total_money
    @hours = invoice_calculator.hours_by_month
    render pdf: "invoice_#{@customer.name + Time.current.strftime('%m-%d-%Y')}",
           template: 'invoices/show.pdf.slim',
           dpi: '600'
  end

  private

  def find_invoice
    @invoice_params = ClientInvoice.find(params[:id])
  end

  def find_customer
    @customer = Customer.find(params[:customer_id] || @invoice_params.customer_id)
  end

  def invoice_calculator
    @invoice_calculator ||= InvoiceCalculator.new(@customer, params[:month])
  end

  def info_empty
    empty_fields = []
    @customer.client_info.attributes.each do |a|
      empty_fields << a[0] unless a[1]
    end
    empty_fields.unshift 'you_must_fill_fields' if empty_fields.present?
    empty_fields
  end

  def invoice_params
    params.require(:invoice).permit(:customer_id).merge(month: params[:invoice][:month].to_date)
  end
end
