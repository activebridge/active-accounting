class ReportHoursController < HoursController
  private

  def hour_params
    params.require(:report_hour).permit(:vendor_id, :customer_id, :hours).merge(month: params[:report_hour][:month].to_date)
  end
end
