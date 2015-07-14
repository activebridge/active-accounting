class OrderFeaturesController < VendorApplicationController
  before_action :find_order, except: [:index, :update]
  before_action :find_feature, only: [:show, :destroy, :update]

  def index
    json = ActiveModel::ArraySerializer.new(Feature.by_group(params[:type]),
                                            each_serializer: FeatureSerializer,
                                            root: nil)
    render json: json, status: 200
  end

  def create
    feature = Feature.new(feature_params)
    if feature.save
      @order.features << feature if @order
      render json: FeatureSerializer.new(feature), status: 200
    else
      render json: {status: :error, error: feature.errors.messages}, status: 422
    end
  end

  def show
    @order.features << @feature if @order && @order.features.exclude?(@feature)
    render json: FeatureSerializer.new(@feature), status: 200
  end

  def destroy
    if @order
      @order.features.delete(@feature)
    else
      @feature.destroy
    end
    head(200)
  end

  def update
    if @feature.update(feature_params)
      render json: FeatureSerializer.new(@feature), status: 201
    else
      render json: {status: :error, error: @feature.errors.messages}, status: 422
    end
  end

  private

  def find_order
    @order = VendorOrder.find_by(id: params[:vendor_order_id])
  end

  def find_feature
    @feature = Feature.find(params[:id])
  end

  def feature_params
    params.require(:feature).permit!
  end
end
