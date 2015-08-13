@ChartsCtrl = ['$scope', 'Chart', 'Register', '$translate', ($scope, Chart, Register, $translate) ->

  $scope.currYear = new Date().getFullYear()
  $scope.myYear = [$scope.currYear]
  $scope.selectedYears = [$scope.currYear]
  $scope.chartLineData = {}
  $scope.load = (year, containerBar) ->
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

  $scope.loadLine = (year) ->
    Register.sumaryProfit
      year: year
      (response) ->
        $scope.chartLineData[year] = JSON.parse(response.profits) if $scope.chartLineData[year] == undefined
        $scope.drawLineChart(year)

  $scope.drawLineChart = (year) ->
    profits_data = []
    $.each $scope.chartLineData[year], (index, value) ->
      profits_data.push([$translate.instant('fullMonthsName').split(',')[index], value])

    lineChart = new JSChart('line_chart' + year, 'line')

    lineChart.setDataArray(profits_data)
    lineChart.setLineColor('#8D9386');
    lineChart.setLineWidth(4)
    lineChart.setTitleColor('#7D7D7D')
    lineChart.setAxisColor('#9F0505')
    lineChart.setGridColor('#a4a4a4')
    lineChart.setAxisValuesColor('#333639')
    lineChart.setAxisNameColor('#333639')
    lineChart.setTextPaddingLeft(0)
    lineChart.setAxisNameX($translate.instant('month'))
    lineChart.setAxisNameY($translate.instant('profit'))
    lineChart.setTitle(year.toString())
    lineChart.setSize(1100, 500)
    lineChart.setFlagRadius(6)
    lineChart.setAxisPaddingLeft(65)
    lineChart.setAxisValuesNumberX(12)
    $.each profits_data, (index, value) ->
      lineChart.setTooltip([value[0], value[1]])

    lineChart.draw()

  loadYears = ->
    Chart.years (response) ->
      $scope.years = response['charts']
      $scope.load($scope.currYear, 'chartcontainer' + $scope.currYear)

  loadYears()

  $scope.CheckYears = (value, clicked, showAttrProfitCharts) ->
    $scope.changeSelectedYears(clicked, value)
    if clicked
      $('#chartcontainer' + value).show()
      $('#line_chart' + value).show()
      if $scope.myYear.indexOf(value) == -1
        $scope.myYear.push(value)
        containerBar = 'chartcontainer' + value
        containerLine = 'line_chart' + value
        $scope.load(value, containerBar)
        $scope.loadLine(value) if showAttrProfitCharts
    else
      $('#chartcontainer' + value).hide()
      $('#line_chart' + value).empty().hide()

    $.each $scope.chartLineData, (year, data) ->
      $scope.drawLineChart(year)

    return

  $scope.showProfitCharts = (years, showAttrProfitCharts) ->
    if showAttrProfitCharts
      $.each $scope.selectedYears, () ->
        $('#line_chart' + @).show()
        $scope.loadLine(@)
    else
      $.each years, () ->
        $('#line_chart' + @).hide()

  $scope.changeSelectedYears = (add, year) ->
    if add
      $scope.selectedYears.push(year) if $scope.selectedYears.indexOf(year) == -1
    else
      $scope.selectedYears.splice($scope.selectedYears.indexOf(year), 1)

]
