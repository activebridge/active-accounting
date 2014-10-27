class RegisterSerializer < ActiveModel::Serializer
  attributes :id, :date, :counterparty, :article, :value, :notes

  def counterparty
    object.counterparty.name if object.counterparty
  end

  def article
    object.article.name_with_type
  end
end
