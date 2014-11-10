@ArticlesCtrl = ['$scope', '$q', 'Article', ($scope, $q , Article) ->
  $scope.articles = Article.query()
  $scope.newArticle = {}
  $scope.newArticle.errors = {}

  $scope.add = ->
    article = Article.save($scope.newArticle,
      () ->
        $scope.articles.push(article)
        $scope.newArticle = {}
      , (response) ->
        $scope.newArticle.errors = response.data.error
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

  $scope.show = () ->
    $('.name, .article_type').removeClass("editable-hide")
    $(".editable-text, .editable-select").remove()
    $('.list').find('.change_buttons').removeClass('ng-hide')
    $('.list').find('.save_buttons').addClass('ng-hide')
    $(this)[0].rowform.$visible = false
    return

  $scope.after_show = () ->
    $(".editable-text, .editable-select").parent().find('.change_buttons').addClass('ng-hide')
    $(".editable-text, .editable-select").parent().find('.save_buttons').removeClass('ng-hide')
    return

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
