@ReportsCtrl = ['$scope', 'Report', ($scope, Report) ->

  $scope.totalRevenue = 0
  $scope.totalCost = 0
  $scope.totalTranslation = 0

  $scope.by_type_items = Report.query
    report_type: 'by_type'

  $scope.revenues = Report.query
    report_type: 'revenues'
    , (response) ->
      $(response).each (k, v) ->
        $scope.totalRevenue += v.value

  $scope.costs = Report.query
    report_type: 'costs'
    , (response) ->
      $(response).each (k, v) ->
        $scope.totalCost += v.value

  $scope.translations = Report.query
    report_type: 'translations'
    , (response) ->
      $(response).each (k, v) ->
        $scope.totalTranslation += v.value
]
