class RegisterSerializer < ActiveModel::Serializer
  attributes :id, :date, :counterparty, :counterparty_id, :article, :article_id, :value, :notes

  def counterparty
    object.counterparty.name if object.counterparty
  end

  def article
    object.article.name_with_type
  end
end
