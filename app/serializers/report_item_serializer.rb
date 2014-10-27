class ReportItemSerializer < ActiveModel::Serializer
  attributes :article, :value

  def article
    object.article_name
  end

  def value
    object.sum
  end
end
