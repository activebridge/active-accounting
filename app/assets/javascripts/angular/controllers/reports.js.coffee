@ReportsCtrl = ['$scope', 'Report', 'Register', ($scope, Report, Register) ->

  $scope.load = ->
    $scope.monthNames = 'JanFebMarAprMayJunJulAugSepOctNovDec'
    $scope.currentMonth = $scope.monthNameByNumber(new Date().getMonth()+1)
    $scope.currentMonthNumber = $scope.monthNames.indexOf($scope.currentMonth) / 3 + 1
    $scope.totalProfits = []
    $scope.totalRevenues = []
    $scope.totalCosts = []
    $scope.totalTranslations = []
    $scope.clicked = []
    $scope.months = []

    $scope.clicked_months = [$scope.dateParse($scope.currentMonthNumber)]
    $scope.clicked = [$scope.currentMonthNumber]
    $scope.loadDatas($scope.clicked_months)

  $scope.dateParse = (month) ->
    year = new Date().getFullYear()
    return month + '/' + year

  $scope.show = (month, clicked) ->
    date = $scope.dateParse($scope.monthNames.indexOf(month) / 3 + 1)
    monthNumber = $scope.monthNames.indexOf(month) / 3 + 1

    if clicked
      $scope.clicked_months.push date
      $scope.loadDatas($scope.clicked_months)
      $scope.clicked.push monthNumber
    else
      monthNumber = $scope.monthNames.indexOf(month) / 3 + 1
      unclickedMonth = $scope.clicked.indexOf(monthNumber)
      trashMonth = $scope.clicked_months.indexOf($scope.dateParse(monthNumber))
      $scope.clicked_months.splice(trashMonth, 1)
      $scope.clicked[unclickedMonth] = null
      $scope.loadDatas($scope.clicked_months)

  $scope.isShow = (month) ->
    return $scope.clicked.indexOf(month) >= 0

  $scope.range = (start, end) ->
    return [start..end]

  $scope.monthNameByNumber = (number) ->
    return $scope.monthNames.substr((number-1)*3, 3)

  $scope.monthByDate = (date) ->
    d = date.split("-")
    return new Date(d[0], d[1] - 1, d[2]).getMonth()+1

  $scope.getRegisters = (month) ->
    $scope.registers = Register.query(month: $scope.dateParse(month))

  $scope.loadDatas = (month) ->
    $scope.revenues = Report.query
      report_type: 'revenues'
      , "month[]": $scope.clicked_months
      , (response) ->
        $scope.totalRevenues = []
        $(response).each (k, v) ->
          $(v.value_sum).each (i, val) ->
            $scope.totalRevenues[val[0]] = 0 unless $scope.totalRevenues[val[0]]
            $scope.totalRevenues[val[0]] += val[1]
            $scope.totalProfits[val[0]] = ($scope.totalRevenues[val[0]] || 0) - ($scope.totalCosts[val[0]] || 0)

    $scope.costs = Report.query
      report_type: 'costs'
      , "month[]": $scope.clicked_months
      , (response) ->
        $scope.totalCosts = []
        $(response).each (k, v) ->
          $(v.value_sum).each (i, val) ->
            $scope.totalCosts[val[0]] = 0 unless $scope.totalCosts[val[0]]
            $scope.totalCosts[val[0]] += val[1]
            $scope.totalProfits[val[0]] = ($scope.totalRevenues[val[0]] || 0) - ($scope.totalCosts[val[0]] || 0)

    $scope.translations = Report.query
      report_type: 'translations'
      , "month[]": $scope.clicked_months
      , (response) ->
        $scope.totalTranslations = []
        $(response).each (k, v) ->
          $(v.value_sum).each (i, val) ->
            $scope.totalTranslations[val[0]] = 0 unless $scope.totalTranslations[val[0]]
            $scope.totalTranslations[val[0]] += val[1]

  $scope.load()

]
