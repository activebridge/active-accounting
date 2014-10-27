@ReportsCtrl = ['$scope', 'Report', ($scope, Report) ->
  $scope.reports = Register.query()

]
