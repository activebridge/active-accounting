class ArticleSerializer < ActiveModel::Serializer
  attributes :id, :name, :type, :assigned
end
