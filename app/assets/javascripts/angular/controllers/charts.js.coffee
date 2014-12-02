@ChartsCtrl = ['$scope', 'Chart', '$translate', ($scope, Chart, $translate) ->

  $scope.currYear = new Date().getFullYear()
  $scope.myYear = [$scope.currYear]
  $scope.load = (year, container) ->
    $scope.data = Chart.query
      year: year
      , (response) ->
        revenueData = []
        costData = []
        translationData = []
        profitData = []

        $(response).each (k, v) ->
          revenueData.push([v.month.toString(), v.revenue, v.cost, v.profit, v.translation])
        generalChart = new JSChart(container, 'bar')
        generalChart.setDataArray(revenueData, 'revenue')

        generalChart.setBarColor('#32CD32', 1)
        generalChart.setBarColor('#F62817', 2)
        generalChart.setBarColor('#008080', 3)
        generalChart.setBarColor('#FDD017', 4)

        generalChart.setLegendShow(true)
        generalChart.setAxisNameX($translate.instant('month'))
        generalChart.setAxisNameY($translate.instant('totall'))

        generalChart.setLegendForBar(1, $translate.instant('Revenue'))
        generalChart.setLegendForBar(2, $translate.instant('Cost'))
        generalChart.setLegendForBar(3, $translate.instant('profit'))
        generalChart.setLegendForBar(4, $translate.instant('Translation'))

        generalChart.setSize(800, 400)
        generalChart.setTitle(year.toString())
        generalChart.setAxisPaddingLeft(65)

        generalChart.draw()

  loadYears = ->
    Chart.years (response) ->
      $scope.years = response['charts']
      $scope.load($scope.currYear, 'chartcontainer' + $scope.currYear)

  loadYears()

  $scope.CheckYears = (value, clicked) ->
    if clicked
      $('#chartcontainer' + value).show()
      if $scope.myYear.indexOf(value) == -1
        $scope.myYear.push(value)
        container = 'chartcontainer' + value
        $scope.load(value, container)
    else
      $('#chartcontainer' + value).hide()
    return
]
