@ArticlesCtrl = ['$scope', '$q', 'Article', '$translate', ($scope, $q , Article, $translate) ->
  $scope.newArticle = {}
  $scope.newArticle.errors = {}

  $scope.articles = Article.query ->
    $('#select').select2({width: '200px'})
    return

  $scope.showSelects = ->
    $('.search-select').select2({width: '200px'})
    return

  $scope.add = ->
    article = Article.save($scope.newArticle,
      () ->
        $scope.articles.push(article)
        $scope.newArticle = {}
        $('#select').select2('val', '')
      , (response) ->
        $scope.newArticle.errors = response.data.error
    )


  $scope.checkName = (data) ->
    "can't be blank"  unless data?

  $scope.type_msgs = [
    { value: "Revenue", text: $translate.instant('Revenue') },
    { value: "Cost", text: $translate.instant('Cost') },
    { value: "Translation", text: $translate.instant('Translation') }
    { value: "Loan", text: $translate.instant('Loan') }
  ]

  $scope.delete = (article_id, index) ->
    if confirm('Впевнений?')
      Article.delete
        id: article_id
      , (success) ->
        $scope.articles.splice(index,1)
        return

  $scope.update = (article_id, data) ->
    d = $q.defer()
    article = Article.update( id: article_id, {article: data}
      (response) ->
        d.resolve()
      (response) ->
        d.resolve response.data.errors['name'][0]
    )
    return d.promise
]
