@ReportsCtrl = ['$scope', 'Report', ($scope, Report) ->

  $scope.load = ->
    $scope.totalRevenue = 0
    $scope.totalCost = 0
    $scope.totalTranslation = 0
    $scope.totalProfit = 0
    $scope.revenues_complete = false
    $scope.costs_complete = false

    $scope.revenues = Report.query
      report_type: 'revenues'
      , month: $('#month-picker').val()
      , (response) ->
        $(response).each (k, v) ->
          $scope.totalRevenue += v.value
        $scope.revenues_complete = true

    $scope.costs = Report.query
      report_type: 'costs'
      , month: $('#month-picker').val()
      , (response) ->
        $(response).each (k, v) ->
          $scope.totalCost += v.value
        $scope.costs_complete = true

    $scope.$watchCollection '[costs_complete, revenues_complete]', () ->
      if $scope.revenues_complete && $scope.costs_complete
        $scope.totalProfit = $scope.totalRevenue - $scope.totalCost

    $scope.translations = Report.query
      report_type: 'translations'
      , month: $('#month-picker').val()
      , (response) ->
        $(response).each (k, v) ->
          $scope.totalTranslation += v.value



  curr_date = new Date()
  $('#month-picker').val((curr_date.getMonth()+1) + '/' + curr_date.getFullYear())

  $('#month-picker').change ->
    $scope.load()

  $('#month-picker').MonthPicker
    ShowIcon: false

  $scope.load()

]
