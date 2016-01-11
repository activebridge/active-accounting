@ChartsCtrl = ['$scope', 'Chart', 'Register', '$translate', ($scope, Chart, Register, $translate) ->

  $scope.currYear = new Date().getFullYear()
  $scope.myYear = [$scope.currYear]
  $scope.charts = {}
  $scope.selectedYears = [$scope.currYear]
  $scope.chartLineData = {}
  $scope.chartBarData = {}

  $scope.load = (year, containerBar) ->
    $scope.data = Chart.query
      year: year,
      (response) ->
        revenueData     = [0,0,0,0,0,0,0,0,0,0,0,0]
        costData        = [0,0,0,0,0,0,0,0,0,0,0,0]
        translationData = [0,0,0,0,0,0,0,0,0,0,0,0]
        profitData      = [0,0,0,0,0,0,0,0,0,0,0,0]
        loanData        = [0,0,0,0,0,0,0,0,0,0,0,0]

        for key in response
          index = key.month - 1
          revenueData[index] = key.revenue
          profitData[index] = key.profit
          translationData[index] = key.translation
          costData[index] = key.cost
          loanData[index] = key.loan

        $scope.chartBarData[year] = { revenue: revenueData, cost: costData, profit: profitData, translation: translationData, loan: loanData }

        if $scope.showAttrProfitCharts
          $scope.setLineChartData(year)
          $scope.drawLineChart(year)

        $scope.drawBarChart(year)

  $scope.setLineChartData = (year) ->
    $scope.chartLineData[year] = []
    allData = _.zip($scope.chartBarData[year]['revenue'], $scope.chartBarData[year]['cost'])
    _.each allData, (data)->
      revenue = data[0]
      cost = data[1]
      profit = revenue - cost
      profitRange = if revenue != 0
        parseFloat(Math.round( (profit * 100)/ revenue ).toFixed(2))
      else
        0
      $scope.chartLineData[year].push(profitRange)

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
      $('#average_rate' + value).show()
      if $scope.myYear.indexOf(value) == -1
        $scope.myYear.push(value)
        containerBar = 'chartcontainer' + value
        containerLine = 'line_chart' + value
        $scope.load(value, containerBar)
    else
      $('#chartcontainer' + value).hide()
      $('#line_chart' + value).hide()
      $('#average_rate' + value).hide()

    return

  $scope.showProfitCharts = (years, showAttrProfitCharts) ->
    year = years[0]
    for year in $scope.selectedYears
      if showAttrProfitCharts
        $('#line_chart' + year).show()
        $('#average_rate' + year).show()
        $scope.drawLineChart(year)
      else
        $('#line_chart' + year).hide()
        $('#average_rate' + year).hide()

  $scope.changeSelectedYears = (add, year) ->
    if add
      $scope.selectedYears.push(year) if $scope.selectedYears.indexOf(year) == -1
    else
      $scope.selectedYears.splice($scope.selectedYears.indexOf(year), 1)

  monthTranslationArray = () ->
    month = []
    $.each $translate.instant('fullMonthsName').split(','), (k, v) ->
      month.push(v)

  $scope.drawLineChart = (year) ->
    return if $scope.charts[year]
    $scope.setLineChartData(year) unless $scope.chartLineData[year]

    list = $scope.chartLineData[year]
    revenue = $scope.chartBarData[year]['revenue']
    cost = $scope.chartBarData[year]['cost']
    average = 0
    length = 0

    for i in [0..(list.length-1)]
      average += list[i]
      unless revenue[i] == 0 && cost[i] == 0
        length += 1

    average /= length
    $('#average_rate' + year).text('Сер. відсоток: ' + Math.round(average) + "%")

    minProfit = Math.min.apply(null, $scope.chartLineData[year])
    minProfit = 0 if minProfit > 0
    months = monthTranslationArray()

    $('#line_chart' + year).highcharts
      chart:
        type: 'line'
      title:
        text: ' '
      tooltip:
        valueSuffix: '%'
        crosshairs: [true, true]
        headerFormat: '{point.key}: '
        pointFormat: '{point.y}'
        footerFormat: ''
        valueDecimals: 2
      legend:
        enabled: false
      ignoreHiddenSeries: true
      xAxis:
        categories: months
      yAxis:
        min: minProfit
        title:
          text: $translate.instant('profit')
      series: [
        {
          name: ' '
          data: $scope.chartLineData[year]
        }
      ]
    $scope.charts[year] = true

  $scope.drawBarChart = (year) ->
    months = monthTranslationArray()

    $('#chartcontainer' + year).highcharts
      chart:
        type: 'column'
      title:
        text: year
      subtitle:
        test: 'SubtitleText'
      colors: ['#32CD32', '#F62817', '#008080', '#FDD017', '#F5F5DC']
      tooltip:
        valueSuffix: ' hrn'
        headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
        pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
                '<td style="padding:0"><b>{point.y:.1f} hrn</b></td></tr>'
        footerFormat: '</table>'
        shared: true
        useHTML: true
      xAxis:
        categories: months
        title:
          text: $translate.instant('month')
      yAxis:
        min: 0
        title:
          text: $translate.instant('totall')
      series: [
        {
          name: $translate.instant('Revenue')
          data: $scope.chartBarData[year]['revenue']
        }
        {
          name: $translate.instant('Cost')
          data: $scope.chartBarData[year]['cost']
        }
        {
          name: $translate.instant('profit')
          data: $scope.chartBarData[year]['profit']
        }
        {
          name: $translate.instant('Translation')
          data: $scope.chartBarData[year]['translation']
          visible: false
        }
        {
          name: $translate.instant('Loan')
          data: $scope.chartBarData[year]['loan']
          visible: false
        }
      ]

]
