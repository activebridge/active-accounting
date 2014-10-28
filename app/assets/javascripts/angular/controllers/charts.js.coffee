@ChartsCtrl = ['$scope', 'Chart', ($scope, Chart) ->
  $scope.data = Chart.query()
]
