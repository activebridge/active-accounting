@ActsCtrl = ['$scope', '$http', ($scope, $http) ->
  $scope.actParams = {
    month: moment().format('MM/YYYY')
  }

  $scope.createAct = ->
    $http.get('acts/' + $scope.actParams.id, params: $scope.actParams).success(
      (response) ->
        $('#generated-act').html response
        $scope.buttonExport = true
        $scope.infoActEmpty = false
    ).error () ->
        $('#generated-act').html ''
        $scope.buttonExport = false
        $scope.infoActEmpty = true
]
