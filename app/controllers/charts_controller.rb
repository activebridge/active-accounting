class ChartsController < ApplicationController
  def index
    json = ActiveModel::ArraySerializer.new(Register.group_by_month,
                                          each_serializer: Charts::GeneralSerializer,
                                          root: nil)

    render json: json, status: 200
  end
end
