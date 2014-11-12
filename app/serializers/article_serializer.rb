class ArticleSerializer < ActiveModel::Serializer
  attributes :id, :name, :type_msg, :type, :assigned
end
