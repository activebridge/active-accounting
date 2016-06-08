class VendorOrdersController < ApplicationController
  before_action :find_order, :group_features, only: :show
  before_action :find_vendor

  def index
    orders = ActiveModel::ArraySerializer.new(@vendor.vendor_orders.order('id desc'),
                                              each_serializer: VendorOrderSerializer,
                                              root: nil)
    render json: orders, status: 200
  end

  def create
    order = VendorOrder.new(vendor_order_params)
    if order.save
      render json: VendorOrderSerializer.new(order), status: 200
    else
      render json: { status: :error, messages:  order.errors }, status: 422
    end
  end

  def show
    respond_to do |format|
      format.pdf do
        render pdf: "order_#{@vendor.name + Time.current.strftime('%m-%d-%Y')}",
               template: 'acts/order_vendor.pdf.erb',
               dpi: '1200'
      end
      format.xlsx { render xlsx: 'acts/order_vendor.xlsx.axlsx', template: 'order_vendor.xlsx.axlsx', filename: 'order_vendor.xlsx' }
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

  def group_features
    features = @order.features
    @primaries = features.by_group('primary')
    @additionals = features.by_group('additional')
  end
end
