class RegisterSerializer < ActiveModel::Serializer
  attributes :id, :date, :counterparty, :article, :value, :notes

  def counterparty
    BasicRegisterSerializer.new(object.counterparty) 
  end

  def article
    name = object.article.name_with_type
    {name: name, id: object.article_id}
  end
end
