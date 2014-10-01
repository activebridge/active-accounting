class ArticleSerializer < ActiveModel::Serializer
  attributes :id, :name, :type_msg, :type

  def type_msg
    {
      'Revenue' => 'надходження',
      'Translation' => 'трансляція',
      'Cost' => 'витрати'
    }[object.type]
  end
end
