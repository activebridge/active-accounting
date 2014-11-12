class RegisterSerializer < ActiveModel::Serializer
  attributes :id, :date, :counterparty, :article, :value, :notes

  def counterparty
    CounterpartyRegisterSerializer.new(object.counterparty) 
  end

  def article
    ArticleRegisterSerializer.new(object.article)
  end
end
