@ChartsCtrl = ['$scope', 'Chart', ($scope, Chart) ->

  $scope.curr_year = new Date().getFullYear()
  $scope.myYear = [$scope.curr_year] 
  $scope.load = (year, count) ->
  
    $scope.data = Chart.query
      year: year
      , (response) ->
        revenueData = []
        costData = []
        translationData = []
        profitData = []

        $(response).each (k, v) ->
          revenueData.push([v.month.toString(), v.revenue, v.cost, v.profit, v.translation])
        generalChart = new JSChart(count, 'bar')
        generalChart.setDataArray(revenueData, 'revenue')


        generalChart.setBarColor('#32CD32', 1)
        generalChart.setBarColor('#F62817', 2)
        generalChart.setBarColor('#008080', 3)
        generalChart.setBarColor('#FDD017', 4)

        generalChart.setLegendShow(true)
        generalChart.setAxisNameX('Місяць')
        generalChart.setAxisNameY('Сума')

        generalChart.setLegendForBar(1, 'Надходження')
        generalChart.setLegendForBar(2, 'Витрати')
        generalChart.setLegendForBar(3, 'Прибуток')
        generalChart.setLegendForBar(4, 'Трансляція')

        generalChart.setSize(800, 400)
        generalChart.setTitle(year+"")
        generalChart.setAxisPaddingLeft(65)

        generalChart.draw()
      
  loadYears = ->
    Chart.years (response) ->
      $scope.years = response[0]['years']

  loadYears()
  $scope.CheckYears = (value, clicked) ->
    if clicked
      $('#chartcontainer'+value).show()
      if $scope.myYear.indexOf(value) <= 0
        $scope.myYear.push(value) if value != $scope.curr_year
        cont = 'chartcontainer'+value
        $scope.load(value, cont)
    else
      $('#chartcontainer'+value).hide()
    return
]
