class RegisterSerializer < ActiveModel::Serializer
  attributes :date, :counterparty, :article, :value, :notes

  def counterparty
    object.counterparty.name
  end

  def article
    object.article.name
  end
end
