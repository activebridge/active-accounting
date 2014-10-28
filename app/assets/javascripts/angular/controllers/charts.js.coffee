@ChartsCtrl = ['$scope', 'Chart', ($scope, Chart) ->
  $scope.data = Chart.query
    year: 2014
    , (response) ->

      revenueData = []
      costData = []
      translationData = []
      profitData = []

      $(response).each (k, v) ->
        revenueData.push([v.month, v.revenue])
        costData.push([v.month, v.cost])
        translationData.push([v.month, v.translation])
        profitData.push([v.month, v.profit])

      generalChart = new JSChart('chartcontainer', 'line')
      generalChart.setDataArray(revenueData, 'revenue')
      generalChart.setDataArray(costData, 'cost')
      generalChart.setDataArray(translationData, 'translation')
      generalChart.setDataArray(profitData, 'profit')
      generalChart.setLineColor('#ff0f0f', 'revenue')
      generalChart.setLineColor('#5555AA', 'translation')
      generalChart.setLineColor('#0fff0f', 'cost')

      generalChart.setLegendShow(true)
      generalChart.setAxisNameX('Місяць')
      generalChart.setAxisNameY('Сума')

      generalChart.setSize(800, 400)

      generalChart.draw()

]
