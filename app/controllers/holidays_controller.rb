class HolidaysController < ApplicationController
  before_filter :authenticate_user!, except: [:by_month, :work_days]
  before_action :find_holiday, only: [:destroy, :update]

  def index
    json = ActiveModel::ArraySerializer.new(Holiday.by_year(params[:year]),
                                            each_serializer: HolidaySerializer,
                                            root: nil)
    render json: json, status: 200
  end

  def create
    holiday = Holiday.new(holiday_params)
    if holiday.save
      render json: HolidaySerializer.new(holiday), status: 200
    else
      render json: {status: :error, error: holiday.errors.messages}, status: 422
    end
  end

  def destroy
    @holiday.destroy
    head(200)
  end

  def update
    if @holiday.update_attributes(holiday_params)
      render json: HolidaySerializer.new(@holiday), status: 201
    else
      render json: {status: :error, error: @holiday.errors.messages}, status: 422
    end
  end

  def by_month
    render json: Holiday.by_month(params[:month].to_date), status: 200
  end

  def work_days
    date = params[:date].to_date
    work_days = WorkDays.new(date)
    render json: { count: work_days.count_by_month }, status: 200
  end

  private

  def holiday_params
    params.require(:holiday).permit!
  end

  def find_holiday
    @holiday = Holiday.find(params[:id])
  end
end
