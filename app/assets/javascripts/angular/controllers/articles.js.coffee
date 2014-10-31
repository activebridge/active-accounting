@ArticlesCtrl = ['$scope', '$q', 'Article', ($scope, $q , Article) ->
  $scope.articles = Article.query()

  $scope.add = ->
    article = Article.save($scope.newArticle,
      () ->
        $scope.articles.push(article)
        $scope.newArticle = {}
    )

  $scope.checkName = (data) ->
    "can't be blank"  unless data?

  $scope.type_msgs = [
    {
      value: "Revenue"
      text: "Надходження"
    }
    {
      value: "Cost"
      text: "Витрати"
    }
    {
      value: "Translation"
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

  $scope.update = (article_id, data) ->
    d = $q.defer()
    article = Article.update( id: article_id, {article: data}
      (response) ->
        $scope.articles = Article.query()
        d.resolve()
      (response) ->
        d.resolve response.data.errors['name'][0]
    )
    return d.promise
]
