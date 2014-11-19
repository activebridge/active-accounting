@ChartsCtrl = ['$scope', 'Chart', ($scope, Chart) ->
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
      loadmass()
  
  loadYears()
  curr_date = new Date() 
  
  loadmass = ->
    i = undefined
    i = 0
    while i < $scope.years.length
      cont = 'chartcontainer'+$scope.years[i]
      $scope.load($scope.years[i], cont)
      i++
]
