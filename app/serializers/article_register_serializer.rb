class ArticleRegisterSerializer < ActiveModel::Serializer
  attributes :id, :name

  def name
    object.name_with_type    
  end
end