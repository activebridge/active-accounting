class VendorActsController < ApplicationController
  before_action :find_act, only: [:show, :update]
  before_action :find_vendor
  before_action :signature, only: :show

  def index
    acts = ActiveModel::ArraySerializer.new(@vendor.vendor_acts.order('id desc'),
                                            each_serializer: VendorActSerializer,
                                            root: nil)
    render json: acts, status: 200
  end

  def create
    return render json: { status: :error, messages: vendor_payment_empty }, status: 422 unless @vendor.value_payment
    @act_params = VendorAct.new(invoice_calculator.params_new_act)
    if @act_params.save
      total_money_words && signature
      respond_to do |format|
        format.html { render 'acts/show_vendor.pdf.erb' }
      end
    else
      render json: { status: :error, messages:  @act_params.errors }, status: 422
    end
  end

  def show
    total_money_words
    respond_to do |format|
      format.html { render 'acts/show_vendor.pdf.erb' }
      format.pdf do
        render pdf: filename,
               template: 'acts/show_vendor.pdf.erb',
               dpi: '1200'
      end
      format.xlsx { render xlsx: 'acts/show_vendor.xlsx.axlsx', template: 'acts/show_vendor.xlsx.axlsx', filename: filename + '.xlsx' }
    end
  end

  def update
    if @act_params.update_attributes(vendor_act__params)
      render json: @act_params, status: 201
    else
      render json: { status: :error, error: 'Something went wrong!' }, status: 422
    end
  end

  private

  def total_money_words
    @total_money_words = invoice_calculator.total_money_words(@act_params.total_money.to_s)
  end

  def find_act
    @act_params = VendorAct.find(params[:id])
  end

  def find_vendor
    @vendor = Vendor.find(params[:vendor_id] || @act_params.vendor_id)
  end

  def invoice_calculator
    @invoice_calculator ||= VendorCalculator.new(@vendor, params)
  end

  def vendor_payment_empty
    { vendor_value_payment: ['no_monthly_payment'] }
  end

  def vendor_act__params
    params.require(:vendor_act).permit(:total_money, :signature_id)
  end

  def signature
    @signature = @act_params.signature
  end

  def filename
    "act_vendor_#{@vendor.name}_#{@act_params.month.strftime('%m_%Y')}"
  end
end
