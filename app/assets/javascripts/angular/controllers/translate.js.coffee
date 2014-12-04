@TranslateCtrl = ['$scope', '$translate', ($scope, $translate) ->

  $scope.changeLanguage = (key) ->
    $translate.use(key)

]
