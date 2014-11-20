@ReportsCtrl = ['$scope', 'Report', ($scope, Report) ->

  $scope.load = ->
    $scope.totalProfit = 0


    Report.query
      report_type: 'revenues'
      , 'months[]': $('#month-picker').val()
      , (response) ->
        $scope.revenues = response[0].articles
        $scope.totalRevenue = response[0].total_values

    Report.query
      report_type: 'costs'
      , 'months[]': $('#month-picker').val()
      , (response) ->
        $scope.costs = response[0].articles
        $scope.totalCost = response[0].total_values

    Report.query
      report_type: 'translations'
      , 'months[]': $('#month-picker').val()
      , (response) ->
        $scope.translation = response[0].articles
        $scope.totalTranslation = response[0].total_values



  curr_date = new Date()
  $('#month-picker').val((curr_date.getMonth()+1) + '/' + curr_date.getFullYear())

  $('#month-picker').change ->
    $scope.load()

  $('#month-picker').MonthPicker
    ShowIcon: false

  $scope.load()

]
