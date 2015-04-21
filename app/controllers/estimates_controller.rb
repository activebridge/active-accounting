class EstimatesController < VendorApplicationController
  before_action :find_estimate, only: [:destroy, :update]

  def index
    json = ActiveModel::ArraySerializer.new(all_estimates.by_month(params[:month]),
                                            each_serializer: EstimateSerializer)
    render json: json, status: 200
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
      render json: @estimate, status: 201
    else
      render json: {status: :error, error: @estimate.errors.messages}, status: 422
    end
  end

  def customers
    render json: Customer.by_active(params[:scope])
  end

  def total_hours
    render json: current_vendor.estimates.hours_by_month.to_json, status: 200
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
    params[:type] ? current_vendor.estimates : Estimate
  end
end
