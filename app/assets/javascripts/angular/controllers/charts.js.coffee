@ChartsCtrl = ['$scope', 'Chart', ($scope, Chart) ->
  $scope.data = Chart.query
    year: 2014
    , (response) ->

      revenueData = []
      costData = []
      translationData = []
      profitData = []

      $(response).each (k, v) ->
        revenueData.push([v.month.toString(), v.revenue, v.cost, v.translation, v.profit])

      generalChart = new JSChart('chartcontainer', 'bar')
      generalChart.setDataArray(revenueData, 'revenue')


      generalChart.setBarColor('#32CD32', 1)
      generalChart.setBarColor('#F62817', 2)
      generalChart.setBarColor('#FDD017', 3)
      generalChart.setBarColor('#008080', 4)

      generalChart.setLegendShow(true)
      generalChart.setAxisNameX('Місяць')
      generalChart.setAxisNameY('Сума')

      generalChart.setLegendForBar(1, 'Надходження')
      generalChart.setLegendForBar(2, 'Витрати')
      generalChart.setLegendForBar(3, 'Трансляція')
      generalChart.setLegendForBar(4, 'Прибуток')

      generalChart.setSize(800, 400)

      generalChart.draw()

]
