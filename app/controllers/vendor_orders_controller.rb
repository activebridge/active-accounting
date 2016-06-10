class VendorOrdersController < ApplicationController
  before_action :find_order, only: [:show, :update]
  before_action :find_vendor
  before_action :signature, :group_features, only: :show

  def index
    orders = ActiveModel::ArraySerializer.new(@vendor.vendor_orders.order('id desc'),
                                              each_serializer: VendorOrderSerializer,
                                              root: nil)
    render json: orders, status: :ok
  end

  def create
    order = VendorOrder.new(vendor_order_params)
    if order.save
      render json: VendorOrderSerializer.new(order), status: :created
    else
      render json: { status: :error, messages:  order.errors }, status: :unprocessable_entity
    end
  end

  def show
    respond_to do |format|
      format.pdf do
        render pdf: filename,
               template: 'acts/order_vendor.pdf.erb',
               dpi: '1200'
      end
      format.xlsx { render xlsx: 'acts/order_vendor.xlsx.axlsx', template: 'acts/order_vendor.xlsx.axlsx', filename: filename + 'order.xlsx' }
    end
  end

  def update
    if @order.update(order_params_update)
      render json: VendorOrderSerializer.new(@order), status: :accepted
    else
      render json: { status: :error, messages:  @order.errors }, status: :unprocessable_entity
    end
  end

  private

  def find_order
    @order = VendorOrder.find(params[:id])
  end

  def find_vendor
    @vendor = Vendor.find(params[:vendor_id] || @order.vendor_id)
  end

  def vendor_order_params
    params.require(:vendor_order).permit!.merge(month: params[:vendor_order][:month].to_date)
  end

  def order_params_update
    params.require(:vendor_order).permit(:signature_id)
  end

  def group_features
    features = @order.features
    @primaries = features.by_group('primary')
    @additionals = features.by_group('additional')
  end

  def signature
    @signature = @order.signature
  end

  def filename
    "order_#{@vendor.name}_#{@order.month.strftime('%m_%Y')}"
  end
end
