class ReportsController < ApplicationController
  before_action :parse_months

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
                                            .by_months(@months),
                                            @months)
    end
  end

  def parse_months
    @months = if params[:month].blank?
                Date.today.month
              else
                months = []
                params['month'].each{|d| months << Date.parse(d).month}
                months.join(',')
              end
  end
end
