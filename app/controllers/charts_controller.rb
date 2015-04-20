class ChartsController < ApplicationController
  def index
    params[:type] == 'plan' ? registers = Plan : registers = Fact
    json = ActiveModel::ArraySerializer.new(registers.by_year(params[:year]).group_by_month,
                                          each_serializer: Charts::GeneralSerializer,
                                          root: nil)
    render json: json, status: 200
  end

  def years
    json = Register.pluck(:date).map(&:year).uniq.sort
    render json: json, status: 200
  end
end
