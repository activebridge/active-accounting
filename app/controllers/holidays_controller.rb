class HolidaysController < ApplicationController
  before_filter :authenticate_user!, except: :index
  before_action :find_holiday, only: [:destroy, :update]

  def index
    json = ActiveModel::ArraySerializer.new(Holiday.by_year(params[:year]).order('date asc'),
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

  private

  def holiday_params
    params.require(:holiday).permit!
  end

  def find_holiday
    @holiday = Holiday.find(params[:id])
  end
end
