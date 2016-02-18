class VacationsController < VendorApplicationController
  before_action :find_vacation, only: [:destroy]

  def index
    vacations = all_vacations.by_year(params[:year])
    json = ActiveModel::ArraySerializer.new(vacations, each_serializer: VacationSerializer)
    render json: json, status: 200
  end

  def create
    vacation = Vacation.new(vacation_params)
    if vacation.save
      render json: VacationSerializer.new(vacation), status: 200
    else
      render json: { status: :error, error: vacation.errors.messages }, status: 422
    end
  end

  def destroy
    @vacation.destroy
    head(200)
  end

  private

  def vacation_params
    params.require(:vacation).permit!.merge(vendor_id: current_counterparty.id)
  end

  def all_vacations
    current_counterparty.vacations
  end

  def find_vacation
    @vacation = Vacation.find(params[:id])
  end
end
