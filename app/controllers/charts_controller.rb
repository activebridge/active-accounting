class ChartsController < ApplicationController
  def index
    json = ActiveModel::ArraySerializer.new(Register.by_year(params[:year]).group_by_month,
                                          each_serializer: Charts::GeneralSerializer,
                                          root: nil)
    render json: json, status: 200
  end

  def years
    json = Register.pluck(:date).map(&:year).uniq.sort
    render json: json, status: 200
  end
end
