class ReportsController < ApplicationController
  def index
    json = ActiveModel::ArraySerializer.new(send(params[:report_type]),
                                           each_serializer: ReportItemSerializer,
                                           root: nil)

    render json: json, status: 200

  end

  private

  def revenues
    Register.revenues.group_by_article
  end

  def costs
    Register.costs.group_by_article
  end

  def translations
    Register.translations.group_by_article
  end

  def by_type
    by_types = Register.by_type.to_a

    revenue = by_types.find { |i| i.type == Article::TYPES::REVENUE }
    cost = by_types.find { |i| i.type == Article::TYPES::COST }

    collection = ByTypeReportItemDecorator.decorate_collection(by_types)
    collection.push(ByTypeReportItemDecorator.new({type: 'Profit', sum: (revenue.sum - cost.sum)}))
  end
end
