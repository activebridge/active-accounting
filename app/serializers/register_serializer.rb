class RegisterSerializer < ActiveModel::Serializer
  attributes :id, :date, :counterparty, :article, :value, :notes, :type

  def counterparty
    CounterpartyRegisterSerializer.new(object.counterparty)
  end

  def article
    ArticleSerializer.new(object.article)
  end

  def type
    object.article.type
  end
end
