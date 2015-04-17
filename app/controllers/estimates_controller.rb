class EstimatesController < VendorApplicationController
  before_action :find_estimate, only: [:destroy, :update]

  def index
    render json: all_estimates, status: 200
  end

  def create
    estimate = Estimate.new(estimate_params)
    if estimate.save
      render json: EstimateSerializer.new(estimate), status: 200
    else
      render json: {status: :error, error: estimate.errors.messages}, status: 422
    end
  end

  def destroy
    @estimate.destroy
    head(200)
  end

  def update
    if @estimate.update(update_params)
      render json: EstimateSerializer.new(@estimate), status: 201
    else
      render json: {status: :error, error: @estimate.errors.messages}, status: 422
    end
  end

  def customers
    render json: Customer.all.by_active(params[:scope])
  end

  private

  def estimate_params
    params.require(:estimate).permit!.merge(vendor_id: current_vendor.id, month: params[:estimate][:month].to_date)
  end

  def update_params
    params.require(:estimate).permit!
  end

  def find_estimate
    @estimate = Estimate.find(params[:id])
  end

  def all_estimates
    params[:month] ? month_etimates : current_vendor_estimates
  end

  def current_vendor_estimates
    ActiveModel::ArraySerializer.new(current_vendor.estimates.order('estimates.month DESC'),
                                     each_serializer: EstimateSerializer)
  end

  def month_etimates
    ActiveModel::ArraySerializer.new(Estimate.by_month(params[:month]),
                                     each_serializer: ReportEstimateSerializer)
  end
end
