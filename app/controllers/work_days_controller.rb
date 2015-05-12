class WorkDaysController < ApplicationController
  before_action :authenticate_user!, except: :index
  before_action :work_days

  def index
    render json: { count: @work_days.count_by_month }, status: 200
  end

  private

  def work_days
    date = params[:date].to_date
    @work_days = WorkDays.new(date)
  end
end
