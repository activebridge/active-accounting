class RegisterSerializer < ActiveModel::Serializer
  attributes :id, :date, :counterparty, :article, :value, :notes

  def counterparty
    CounterpartyRegisterSerializer.new(object.counterparty)
  end

  def article
    ArticleSerializer.new(object.article)
  end
end
