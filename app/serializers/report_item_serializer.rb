class ReportItemSerializer < ActiveModel::Serializer
  attributes :article, :value, :counterparties, :registers, :value_sum, :article_type

  def article
    object.article_name
  end

  def article_type
    object.type
  end

  def value
    object.sum.round(2)
  end

  def counterparties
    ActiveModel::ArraySerializer.new(object.counterparties,
                                    each_serializer: CounterpartyReportItemSerializer,
                                    root: nil)
  end

  def registers
    ActiveModel::ArraySerializer.new(object.registers,
                                    each_serializer: RegisterSerializer,
                                    root: nil)
  end

  def value_sum
    ActiveModel::ArraySerializer.new(object.value_sum,
                                    root: nil)
  end
end
