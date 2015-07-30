@ChartsCtrl = ['$scope', 'Chart', 'Register', '$translate', ($scope, Chart, Register, $translate) ->

  $scope.currYear = new Date().getFullYear()
  $scope.myYear = [$scope.currYear]
  $scope.load = (year, containerBar, containerLine) ->
    $scope.data = Chart.query
      year: year,
      (response) ->
        revenueData = []
        costData = []
        translationData = []
        profitData = []
        loanData = []

        $(response).each (k, v) ->
          revenueData.push([v.month.toString(), v.revenue, v.cost, v.profit, v.translation, v.loan])
        generalChart = new JSChart(containerBar, 'bar')
        generalChart.setDataArray(revenueData, 'revenue')

        generalChart.setBarColor('#32CD32', 1)
        generalChart.setBarColor('#F62817', 2)
        generalChart.setBarColor('#008080', 3)
        generalChart.setBarColor('#FDD017', 4)
        generalChart.setBarColor('#F5F5DC', 5)

        generalChart.setLegendShow(true)
        generalChart.setAxisNameX($translate.instant('month'))
        generalChart.setAxisNameY($translate.instant('totall'))

        generalChart.setLegendForBar(1, $translate.instant('Revenue'))
        generalChart.setLegendForBar(2, $translate.instant('Cost'))
        generalChart.setLegendForBar(3, $translate.instant('profit'))
        generalChart.setLegendForBar(4, $translate.instant('Translation'))
        generalChart.setLegendForBar(5, $translate.instant('Loan'))

        generalChart.setSize(1200, 500)
        generalChart.setTitle(year.toString())
        generalChart.setAxisPaddingLeft(65)

        generalChart.draw()

    $scope.profit = Register.sumaryProfit
      year: year
      (response) ->
        profits_data = []
        $(response.profits).each (k, v) ->
          profits_data.push(v)

        console.log profits_data[0]
        lineChart = new JSChart(containerLine, 'line')

        lineChart.setDataArray(profits_data)
        lineChart.setLineColor('#8D9386');
        lineChart.setLineWidth(4)
        lineChart.setTitleColor('#7D7D7D')
        lineChart.setAxisColor('#9F0505')
        lineChart.setGridColor('#a4a4a4')
        lineChart.setAxisValuesColor('#333639')
        lineChart.setAxisNameColor('#333639')
        lineChart.setTextPaddingLeft(0)
        lineChart.setAxisNameX('Month')
        lineChart.setAxisNameY('Total')
        lineChart.setTitle(year.toString())
        lineChart.setLabelY([100, '100%'])
        lineChart.setSize(1200, 500)
        lineChart.setFlagRadius(6)
        lineChart.setAxisPaddingLeft(65)
        $.each profits_data, (index, value) ->
          console.log value
          console.log profits_data[index]
          lineChart.setTooltip([value[0], value[1]])

        lineChart.draw()


  loadYears = ->
    Chart.years (response) ->
      $scope.years = response['charts']
      $scope.load($scope.currYear, 'chartcontainer' + $scope.currYear, 'line_chart' + $scope.currYear)

  loadYears()

  $scope.CheckYears = (value, clicked) ->
    if clicked
      $('#chartcontainer' + value).show()
      $('#line_chart' + value).show()
      if $scope.myYear.indexOf(value) == -1
        $scope.myYear.push(value)
        containerBar = 'chartcontainer' + value
        containerLine = 'line_chart' + value
        $scope.load(value, containerBar. containerLine)
    else
      $('#chartcontainer' + value).hide()
      $('#line_chart' + value).hide()
    return

]
