class MissingHoursController < ApplicationController
  def index
    json = ActiveModel::ArraySerializer.new(Vendor.by_missing_hours)
    render json: json, status: 200
  end
end
