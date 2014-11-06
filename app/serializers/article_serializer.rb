class ArticleSerializer < ActiveModel::Serializer
  attributes :id, :name, :type_msg, :type, :employment

  def employment
    true if Register.where(article_id: id) != []
  end
end
