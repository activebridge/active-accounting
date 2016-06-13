class ActsController < ApplicationController
  before_action :find_act, only: [:show, :update, :destroy]
  before_action :find_customer
  before_action :find_variables, only: [:create, :show]
  before_action :signature, only: :show

  def index
    acts = ActiveModel::ArraySerializer.new(@customer.client_acts.order('id desc'),
                                            each_serializer: ClientActSerializer,
                                            root: nil)
    render json: acts, status: 200
  end

  def create
    @act_params = ClientAct.new(act_params)
    if @act_params.save
      signature
      respond_to do |format|
        format.html { render 'acts/show_customer.pdf.erb' }
      end
    else
      render json: { status: :error, messages: @act_params.errors }, status: 422
    end
  end

  def update
    if @act_params.update(act_params_update)
      render json: ClientActSerializer.new(@act_params), status: 201
    else
      render json: { status: :error, error: @act_params.errors }, status: 422
    end
  end

  def show
    respond_to do |format|
      format.html { render 'acts/show_customer.pdf.erb' }
      format.pdf do
        render pdf: filename,
               template: 'acts/show_customer.pdf.erb',
               dpi: '1200'
      end
      format.xlsx { render xlsx: 'show_customer', filename: filename + '.xlsx' }
    end
  end

  def destroy
    @act_params.destroy
    head(200)
  end

  private

  def find_variables
    @total_by_hours = @act_params ? @act_params.total_money : invoice_calculator.total_money
    @act_date = params[:month].to_date
  end

  def find_act
    @act_params = ClientAct.find(params[:id])
  end

  def find_customer
    @customer = Customer.find(params[:customer_id] || @act_params.customer_id)
  end

  def invoice_calculator
    @invoice_calculator ||= InvoiceCalculator.new(@customer, params[:month])
  end

  def act_params
    params.require(:act).permit(:customer_id).merge(month: params[:act][:month].to_date, total_money: @total_by_hours)
  end

  def act_params_update
    params.require(:act).permit(:total_money, :signature_id)
  end

  def signature
    @signature = @act_params.signature
  end

  def filename
    "act_#{@customer.name}_#{params[:month].tr!('/', '_')}"
  end
end
