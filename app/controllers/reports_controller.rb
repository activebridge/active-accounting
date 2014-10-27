class ReportsController < ApplicationController
  def index
    json = ActiveModel::ArraySerializer.new(send(params[:report_type]),
                                           each_serializer: ReportItemSerializer,
                                           root: nil)

    render json: json, status: 200

  end

  private

  def revenues
    RegisterDecorator.decorate_collection(Register.revenues.group_by_article)
  end

  def costs
    RegisterDecorator.decorate_collection(Register.costs.group_by_article)
  end

  def translations
    RegisterDecorator.decorate_collection(Register.translations.group_by_article)
  end
end
