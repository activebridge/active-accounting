class ReportsController < ApplicationController
  before_action :parse_month

  def index
    json = ActiveModel::ArraySerializer.new(send(params[:report_type]),
                                           each_serializer: ReportItemSerializer,
                                           root: nil)

    render json: json, status: 200

  end

  private

  [:revenues, :costs, :translations].each do |type|
    define_method(type) do
      RegisterDecorator.decorate_collection(Register.send(type)
                                            .group_by_article
                                            .by_months(@month),
                                            @month)
    end
  end

  def parse_month
    @month = if params[:month].blank?
               '0'
             else
               months = []
               params[:month].each{|m| months << Date.parse(m).month}
               months.join(',')
             end
  end
end
