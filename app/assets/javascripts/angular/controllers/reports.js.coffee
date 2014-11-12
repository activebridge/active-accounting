@ReportsCtrl = ['$scope', 'Report', ($scope, Report) ->

  $scope.load = ->
    $scope.monthNames = 'JanFebMarAprMayJunJulAugSepOctNovDec'
    $scope.currentMonth = $scope.monthNameByNumber(new Date().getMonth()+1)
    $scope.currentMonthNumber = $scope.monthNames.indexOf($scope.currentMonth) / 3 + 1
    $scope.totalProfits = []
    $scope.totalRevenues = []
    $scope.totalCosts = []
    $scope.totalTranslations = []
    $scope.revenues = []
    $scope.costs = []
    $scope.translations = []
    $scope.clicked = []

    $scope.loadDates($scope.currentMonthNumber)
    $scope.clicked[$scope.currentMonthNumber] = true

  $scope.dateParse = (month) ->
    year = new Date().getFullYear()
    return month + '/' + year

  $scope.show = (month, clicked) ->
    date = $scope.dateParse month
    monthNumber = $scope.monthNames.indexOf(month) / 3 + 1

    if clicked
      $scope.loadDates(monthNumber)
      $scope.clicked[monthNumber] = true
    else
      $scope.clicked[monthNumber] = false
      $scope.revenues[monthNumber] = null
      $scope.costs[monthNumber] = null
      $scope.translations[monthNumber] = null

  $scope.range = (start, end) ->
    return [start..end]

  $scope.monthNameByNumber = (number) ->
    return $scope.monthNames.substr((number-1)*3, 3)

  $scope.loadDates = (month) ->
    $scope.revenues[month] = Report.query
      report_type: 'revenues'
      , month: $scope.dateParse(month)
      , (response) ->
        $scope.totalRevenues[month] = 0
        $(response).each (k, v) ->
          $scope.totalRevenues[month] += v.value
        $scope.totalProfits[month] = $scope.totalRevenues[month] - $scope.totalCosts[month]

    $scope.costs[month] = Report.query
      report_type: 'costs'
      , month: $scope.dateParse(month)
      , (response) ->
        $scope.totalCosts[month] = 0
        $(response).each (k, v) ->
          $scope.totalCosts[month] += v.value
        $scope.totalProfits[month] = $scope.totalRevenues[month] - $scope.totalCosts[month]

    $scope.translations[month] = Report.query
      report_type: 'translations'
      , month: $scope.dateParse(month)
      , (response) ->
        $scope.totalTranslations[month] = 0
        $(response).each (k, v) ->
          $scope.totalTranslations[month] += v.value

  $scope.load()

]
