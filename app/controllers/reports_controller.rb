class ReportsController < ApplicationController
  def index
    json = ActiveModel::ArraySerializer.new(send(params[:report_type]),
                                           each_serializer: ReportItemSerializer,
                                           root: nil)

    render json: json, status: 200

  end

  private

  def by_article
    revenues = Register.revenues.group_by_article
    costs = Register.costs.group_by_article
    translations = Register.translations.group_by_article
    revenues + costs + translations
  end

  def by_type
    revenue = Register.revenues.group_by_article_type.first
    cost = Register.costs.group_by_article_type.first
    translation = Register.translations.group_by_article_type.first

    collection = ByTypeReportItemDecorator.decorate_collection([revenue, cost, translation])
    collection.push(ByTypeReportItemDecorator.new({type: 'Profit', sum: (revenue.sum - cost.sum)}))
  end
end
