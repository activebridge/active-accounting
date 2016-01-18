class HoursController < VendorApplicationController
  before_action :find_hour, only: [:destroy, :update]
  before_action :approve_hours_service, only: [:approve_hours, :confirm]
  before_filter :redirect_to_hr_manager

  def index
    hours = all_hours.by_customer(params[:customer_id]).by_month(params[:month]).by_vendor(params[:vendor_id])
    json = ActiveModel::ArraySerializer.new(hours, each_serializer: HourSerializer)
    render json: json, status: 200
  end

  def create
    hour = Hour.new(hour_params)
    if hour.save
      render json: HourSerializer.new(hour), status: 200
    else
      render json: {status: :error, error: hour.errors.messages}, status: 422
    end
  end

  def destroy
    @hour.destroy
    head(200)
  end

  def update
    if @hour.update(update_params)
      render json: @hour, status: 201
    else
      render json: {status: :error, error: @hour.errors.messages}, status: 422
    end
  end

  def total_hours
    render json: all_hours.hours_by_month(params[:year]).to_json, status: 200
  end

  def years
    render json: { years: all_hours.uniq_years }, status: 200
  end

  def approve_hours
    @approve_hours.working
    render json: { status: :ok }, status: 200
  end

  def confirm
    if @approve_hours.confirm(params[:token])
      flash.now[:notice] = 'Thanks, your autofilled hours have been confirmed!'
    else
      render file: "#{Rails.root}/public/404.html", layout: false, status: 404
    end
  end

  private

  def hour_params
    params.require(:hour).permit!.merge(vendor_id: current_counterparty.id, month: params[:hour][:month].to_date)
  end

  def update_params
    params.require(:hour).permit!
  end

  def find_hour
    @hour = Hour.find(params[:id])
  end

  def approve_hours_service
    @approve_hours ||= ApproveHours.new
  end

  def all_hours
    params[:type] == 'vendor' ? current_counterparty.hours : Hour
  end
end
