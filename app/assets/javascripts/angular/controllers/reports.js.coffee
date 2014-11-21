@ReportsCtrl = ['$scope', 'Report', 'Register', ($scope, Report, Register) ->

  $scope.load = ->
    $scope.months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
    curr_date = new Date()
    $scope.clickedMonths = [(curr_date.getMonth()+1) + '/' + curr_date.getFullYear()]
    $scope.currentMonth = $scope.months[curr_date.getMonth()]
    $scope.loadDates()

  $scope.loadDates = ->
    Report.query
      report_type: 'revenues'
      , 'months[]': $scope.clickedMonths
      , (response) ->
        $scope.revenues = response[0].articles
        $scope.totalRevenue = response[0].total_values

    Report.query
      report_type: 'costs'
      , 'months[]': $scope.clickedMonths
      , (response) ->
        $scope.costs = response[0].articles
        $scope.totalCost = response[0].total_values

    Report.query
      report_type: 'translations'
      , 'months[]': $scope.clickedMonths
      , (response) ->
        $scope.translations = response[0].articles
        $scope.totalTranslation = response[0].total_values

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

  $scope.getRegisters = (month, event, clicked) ->
    date = month + '/' + (new Date().getFullYear())
    registers = Register.query (month: date) ->
      html = $('#registers-template').clone()
      #$(event.target.parentElement).after("<sg-register-table registers=" + registers + " show=" + clicked + "></sg-register-table>")

  $scope.load()

]
