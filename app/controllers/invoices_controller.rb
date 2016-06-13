class InvoicesController < ApplicationController
  before_action :find_invoice, only: [:show, :update, :destroy]
  before_action :find_customer
  before_action :signature, only: :show

  def index
    invoices = ActiveModel::ArraySerializer.new(@customer.client_invoices.order('id desc'),
                                                each_serializer: ClientInvoiceSerializer,
                                                root: nil)
    render json: invoices, status: 200
  end

  def create
    invoice = ClientInvoice.new(invoice_params)
    if invoice.save
      render json: ClientInvoiceSerializer.new(invoice), status: 200
    else
      render json: { status: :error, messages: invoice.errors }, status: 422
    end
  end

  def show
    invoice_calculator
    respond_to do |format|
      format.html { render 'invoices/show.pdf.slim' }
      format.pdf do
        render pdf: filename,
               template: 'invoices/show.pdf.slim',
               dpi: '600'
      end
      format.xlsx { render xlsx: 'show', filename: filename + '.xlsx' }
    end
  end

  def destroy
    @invoice_params.destroy
    head(200)
  end

  def update
    if @invoice_params.update(invoice_params_update)
      render json: ClientInvoiceSerializer.new(@invoice_params), status: :accepted
    else
      render json: { status: :error, messages: @invoice_params.errors }, status: :unprocessable_entity
    end
  end

  private

  def find_invoice
    @invoice_params = ClientInvoice.find(params[:id])
  end

  def find_customer
    @customer = Customer.find(params[:customer_id] || @invoice_params.customer_id)
  end

  def invoice_calculator
    invoice_calculator = InvoiceCalculator.new(@customer, params[:month])
    @invoice_number = invoice_calculator.invoice_number
    @total_money = invoice_calculator.total_money
    @hours = invoice_calculator.hours_by_month
  end

  def invoice_params
    params.require(:invoice).permit(:customer_id).merge(month: params[:invoice][:month].to_date)
  end

  def invoice_params_update
    params.require(:invoice).permit(:signature_id)
  end

  def signature
    @signature = @invoice_params.signature
  end

  def filename
    "invoice_#{@customer.name}_#{params[:month].tr!('/', '_')}"
  end
end
