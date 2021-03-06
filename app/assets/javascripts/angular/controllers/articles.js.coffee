@ArticlesCtrl = ['$scope', '$q', 'Article', '$translate', ($scope, $q , Article, $translate) ->
  $scope.newArticle = {}
  $scope.newArticle.errors = {}

  $scope.load = ->
    $scope.articles = Article.query
      type: $scope.showGroup
      () ->
        $('#select').select2({width: '200px'})
        return

  $scope.showGroup = 'Revenue'

  $scope.changeGroup = (group) ->
    $scope.showGroup = group
    $scope.load()

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

  $scope.article_types = $.map(gon.article_types, (type) ->
    type = type.substring(0, 1).toUpperCase() + type.substring(1).toLowerCase()
    {
      value: type
      text: $translate.instant(type)
    }
  )

  $scope.load()
]
