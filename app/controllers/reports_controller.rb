class ReportsController < ApplicationController
  def index
    json = ReportsJsonBuilder.new(params[:months], params[:report_type], params[:rate_currency])
    render json: json, status: 200
  end

  def years
    json = Register.pluck(:date).map(&:year).uniq.sort
    render json: json, status: 200
  end
end
