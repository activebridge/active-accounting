class InvoicesController < ApplicationController
  before_action :find_customer

  def index
    invoices = ActiveModel::ArraySerializer.new(@customer.invoices.order('id desc'),
                                           each_serializer: InvoiceSerializer,
                                           root: nil)
    render json: invoices, status: 200
  end

  def show
    @invoice_number = invoice_calculator.invoice_number
    @total_money = invoice_calculator.total_money
    @hours = invoice_calculator.hours_by_month
    render pdf: "invoice_#{@customer.name + Time.current.strftime('%m-%d-%Y')}",
           template: 'invoices/show.pdf.slim',
           dpi: '600'
  end

  def create
    if invoice_calculator.hours_by_month.present?
      @invoice = Invoice.new(invoice_params)
      if @invoice.save
        head :ok
      else
        render json: { status: :error, messages: @invoice.errors.messages[:month] }, status: 422
      end
    else
      render json: { status: :error, messages: ['no hours for this month'] }, status: 422
    end
  end

  private

  def find_customer
    @customer = Customer.find_by_id(params[:customer_id] || params[:id])
  end

  def invoice_calculator
    @invoice_calculator ||= InvoiceCalculator.new(@customer, params[:month])
  end

  def find_month
    Invoice.find_by_id(params[:id]).month
  end

  def invoice_params
    params.require(:invoice).permit!.merge!(month: params[:invoice][:month].to_date)
  end
end