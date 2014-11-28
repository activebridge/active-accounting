class RegisterSerializer < ActiveModel::Serializer
  attributes :id, :date, :counterparty, :article, :value, :notes, :background

  def counterparty
    CounterpartyRegisterSerializer.new(object.counterparty)
  end

  def article
    ArticleSerializer.new(object.article)
  end

  def date
    object.date.strftime('%d-%m-%Y')
  end
end
