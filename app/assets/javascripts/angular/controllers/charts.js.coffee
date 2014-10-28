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


      generalChart.setBarColor('#ff0f0f', 1)
      generalChart.setBarColor('#5555AA', 2)
      generalChart.setBarColor('#0fff0f', 3)
      generalChart.setBarColor('#E4DB7B', 4)

      generalChart.setLegendShow(true)
      generalChart.setAxisNameX('Місяць')
      generalChart.setAxisNameY('Сума')

      generalChart.setLegendForBar(1, 'Revenue')
      generalChart.setLegendForBar(2, 'Cost')
      generalChart.setLegendForBar(3, 'Translation')
      generalChart.setLegendForBar(4, 'Profit')

      generalChart.setSize(800, 400)

      generalChart.draw()

]
