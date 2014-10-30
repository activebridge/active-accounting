@ArticlesCtrl = ['$scope', '$q', 'Article', ($scope, $q , Article) ->
  $scope.articles = Article.query()

  $scope.add = ->
    article = Article.save($scope.newArticle,
      () ->
        $scope.articles.push(article)
        $scope.newArticle = {}
    )

  $scope.type_msgs = [
    {
      value: 1
      text: "Надходження"
    }
    {
      value: 2
      text: "Витрати"
    }
    {
      value: 3
      text: "Трансляція"
    }
  ]

  $scope.delete = (article_id) ->
    if confirm('Впевнений?')
      Article.delete
        id: article_id
      , (success) ->
        $scope.articles = Article.query()
        return

  $scope.update = (article_id, name) ->
    d = $q.defer()
    Article.update( id: article_id, {article: {name: name}}
      () ->
        d.resolve()
      (response) ->
        d.resolve response.data.errors['name'][0]
    )
    return d.promise

]
