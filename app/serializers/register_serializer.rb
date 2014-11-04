class RegisterSerializer < ActiveModel::Serializer
  attributes :id, :date, :counterparty, :article, :value, :notes

  def counterparty
    name = object.counterparty.name if object.counterparty
   	{name: name, id: object.counterparty_id}
  end

  def article
  	name = object.article.name_with_type
    {name: name, id: object.article_id}
  end
end
