class RegisterSerializer < ActiveModel::Serializer
  attributes :id, :date, :counterparty, :vendor, :article, :value, :notes, :background, :currency

  def counterparty
    CounterpartyRegisterSerializer.new(object.counterparty)
  end

  def vendor
    CounterpartyRegisterSerializer.new(object.vendor)
  end

  def article
    ArticleSerializer.new(object.article)
  end

  def date
    object.date.strftime('%d-%m-%Y')
  end
end
