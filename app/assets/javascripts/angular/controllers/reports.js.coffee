@ReportsCtrl = ['$scope', 'Report', 'Register', ($scope, Report, Register) ->

  $scope.load = ->
    $scope.totalProfit = 0
    $scope.months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
    curr_date = new Date()
    $scope.clickedMonths = [(curr_date.getMonth()+1) + '/' + curr_date.getFullYear()]
    $scope.currentMonth = $scope.months[curr_date.getMonth()]

    $scope.loadDates()

  $scope.loadDates = ->
    $scope.revenues = Report.query
      report_type: 'revenues'
      , 'month[]': $scope.clickedMonths
      , (response) ->
        $scope.totalRevenue = []
        $(response).each (k, v) ->
          $.each v.value, (key, value) ->
            $scope.totalRevenue[key] = 0 unless $scope.totalRevenue[key]
            $scope.totalRevenue[key] += value

    $scope.costs = Report.query
      report_type: 'costs'
      , 'month[]': $scope.clickedMonths
      , (response) ->
        $scope.totalCost = []
        $(response).each (k, v) ->
          $.each v.value, (key, value) ->
            $scope.totalCost[key] = 0 unless $scope.totalCost[key]
            $scope.totalCost[key] += value

    $scope.$watchCollection '[totalRevenue, totalCost]', () ->
      $scope.totalProfit = $scope.totalRevenue - $scope.totalCost

    $scope.translations = Report.query
      report_type: 'translations'
      , 'month[]': $scope.clickedMonths
      , (response) ->
        $scope.totalTranslation = []
        $(response).each (k, v) ->
          $.each v.value, (key, value) ->
            $scope.totalTranslation[key] = 0 unless $scope.totalTranslation[key]
            $scope.totalTranslation[key] += value

  $scope.getRegisters = (month, article_id, type) ->
    date = month + '/' + (new Date().getFullYear())
    $scope.registers = Register.query(month: date, article_id: article_id, type: type)
    console.log $(".total-revenue")

  $scope.monthsChange = (month, clicked) ->
    m = $scope.months.indexOf(month)+1
    y = new Date().getFullYear()
    date = m + '/' + y
    if clicked
      $scope.clickedMonths.push date
    else
      trashMonth = $scope.clickedMonths.indexOf(date)
      $scope.clickedMonths.splice(trashMonth, 1)
    $scope.loadDates()

  $scope.range = (start, end) ->
    return [start..end]

  $scope.isShow = (month) ->
    y = new Date().getFullYear()
    date = month + '/' + y
    return $scope.clickedMonths.indexOf(date) >= 0

  $scope.parseMonthName = (month) ->
    return $scope.months.indexOf(month)+1

  $scope.load()

]
