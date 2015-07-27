class VendorActsController < ApplicationController
  before_action :find_act, only: :show
  before_action :find_vendor

  def index
    acts = ActiveModel::ArraySerializer.new(@vendor.vendor_acts.order('id desc'),
                                           each_serializer: VendorActSerializer,
                                           root: nil)
    render json: acts, status: 200
  end

  def create
    if @vendor.value_payment.nil? || info_empty.length > 0
      messages = @vendor.value_payment ? info_empty : ['no_monthly_payment']
      render json: {status: :error, messages: messages}, status: 422
    else
      @act_params = VendorAct.new(invoice_calculator.params_new_act)
      if @act_params.save
        @total_money_words = invoice_calculator.total_money_words(@act_params.total_money.to_s)
        respond_to do |format|
          format.html { render "acts/show_vendor.pdf.erb" }
        end
      else
        render json: {status: :error}, status: 422
      end
    end
  end

  def show
    @total_money_words = invoice_calculator.total_money_words(@act_params.total_money.to_s)
    respond_to do |format|
      format.html { render "acts/show_vendor.pdf.erb" }
      format.pdf do
        render pdf: "act_#{@vendor.name + Time.current.strftime('%m-%d-%Y')}",
               template: "acts/show_vendor.pdf.erb",
               dpi: '1200'
      end
    end
  end

  private

  def find_act
    @act_params = VendorAct.find(params[:id])
  end

  def find_vendor
    @vendor = Vendor.find(params[:vendor_id] || @act_params.vendor_id)
  end

  def invoice_calculator
    @invoice_calculator ||= VendorCalculator.new(@vendor, params)
  end

  def info_empty
    empty_fields = []
    @vendor.vendor_info.attributes.each do |a|
      empty_fields.push a[0] unless a[1]
    end
    empty_fields.unshift 'you_must_fill_fields' if empty_fields.length > 0
    empty_fields
  end
end
