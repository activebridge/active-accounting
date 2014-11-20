class ReportItemSerializer < ActiveModel::Serializer
  attributes :article, :value, :counterparties, :article_type, :article_id

  def article
    object.article_name
  end

  def article_type
    object.type
  end

  def value
    object.value_sum object.month
  end

  def article_id
    object.register.article_id
  end

  def counterparties
    ActiveModel::ArraySerializer.new(object.counterparties,
                                    each_serializer: CounterpartyReportItemSerializer,
                                    root: nil)
  end
end
