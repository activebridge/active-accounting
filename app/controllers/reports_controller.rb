class ReportsController < ApplicationController
  def index
    json = ReportsJsonBuilder.new(params[:months], params[:report_type])
    render json: json, status: 200
  end
end
