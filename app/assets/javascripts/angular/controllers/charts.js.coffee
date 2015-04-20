@ChartsCtrl = ['$scope', 'Chart', '$translate', ($scope, Chart, $translate) ->

  months = $translate.instant('month_all').split(',')
  $scope.currYear = new Date().getFullYear()
  $scope.myYear = [$scope.currYear]

  $scope.addBlankValues = (array) ->
    if array.length < 12

      #add in array current months
      i = 0
      isMonths = []
      while i < array.length
        isMonths.push(array[i].month)
        i++

      #add in array empty values
      i = 0
      while i < 12
        if isMonths.indexOf(i+1) == -1
          array.push({"month":i+1,"revenue":0.0,"cost":0.0,"profit":0.0,"translation":0.0,"loan":0.0})
        i++
      array.sort (a, b) ->
        if a.month > b.month
          return 1
        if a.month < b.month
          return -1
        0

  $scope.load = (year, container) ->
    Chart.query
      year: year
      type: 'plan'
      , (response) ->
        revenueDataPlan     = []
        costDataPlan        = []
        translationDataPlan = []
        profitDataPlan      = []
        loanDataPlan        = []
        $($scope.addBlankValues(response)).each (k, v) ->
          revenueDataPlan.push([v.month-1, v.revenue])
          costDataPlan.push([v.month-1, v.cost])
          translationDataPlan.push([v.month-1, v.translation])
          profitDataPlan.push([v.month-1, v.profit])
          loanDataPlan.push([v.month-1, v.loan])

        Chart.query
          year: year
          , (response) ->
            revenueDataFact     = []
            costDataFact        = []
            translationDataFact = []
            profitDataFact      = []
            loanDataFact        = []

            $($scope.addBlankValues(response)).each (k, v) ->
              revenueDataFact.push([v.month-1, v.revenue])
              costDataFact.push([v.month-1, v.cost])
              translationDataFact.push([v.month-1, v.translation])
              profitDataFact.push([v.month-1, v.profit])
              loanDataFact.push([v.month-1, v.loan])

            $('#chartcontainer' + year).highcharts
              chart:
                type: 'column'
                width: 1250
                height: 500
              title:
                text: year
                y: 5
              xAxis:
                categories: months
                title:
                  text: $translate.instant('month')
              crosshair: true
              yAxis:
                min: 0
                title:
                  text: $translate.instant('totall')
              legend:
                y:40
                verticalAlign: 'top'
              tooltip:
                headerFormat: '<span style="font-size:10px">{point.key}</span><table>'
                pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
                  '<td style="padding:0"><b>{point.y:.1f} грн</b></td></tr>'
                footerFormat: '</table>'
                shared: true
                useHTML: true
              plotOptions:
                series:
                  borderWidth: 0
                  dataLabels:
                      enabled: true
                      format: '{point.y:.1f}'
                column:
                  pointPadding: 0.2
                  borderWidth: 0
              series: [
                {
                  name: $translate.instant('Revenue')
                  color: '#32CD32'
                  data: revenueDataFact
                }
                {
                  name: $translate.instant('revenue_plan')
                  color: '#00ff9d'
                  data: revenueDataPlan
                  visible: false
                }
                {
                  name: $translate.instant('Cost')
                  color: '#F62817'
                  data: costDataFact
                }
                {
                  name: $translate.instant('cost_plan')
                  color: '#d66f6f'
                  data: costDataPlan
                  visible: false
                }
                {
                  name: $translate.instant('profit')
                  color: '#008080'
                  data: profitDataFact
                }
                {
                  name: $translate.instant('profit_plan')
                  color: '#64c4c4'
                  data: profitDataPlan
                  visible: false
                }
                {
                  name: $translate.instant('Translation')
                  color: '#9b6425'
                  data: translationDataFact
                }
                {
                  name: $translate.instant('translation_plan')
                  color: '#f29d2e'
                  data: translationDataPlan
                  visible: false
                }
                {
                  name: $translate.instant('Loan')
                  color: '#f702ce'
                  data: loanDataFact
                }
                {
                  name: $translate.instant('loan_plan')
                  color: '#d88cca'
                  data: loanDataPlan
                  visible: false
                }
              ]

            $('#chartcontainer' + year).before('<div>
                                                 <label>'+ $translate.instant('all_plans')+'</label>
                                                 <input id="'+year+'" type="checkbox" class="showPlanData" />
                                                </div>')

            $('#' + year).on 'click', ->
              chart = $('#chartcontainer' + year).highcharts()
              $(chart.series).each (index) ->
                unless index % 2 == 0
                  if this.visible
                    this.hide()
                  else
                    this.show()
                  return
                return

  loadYears = ->
    Chart.years (response) ->
      $scope.years = response['charts']
      $scope.load($scope.currYear, 'chartcontainer' + $scope.currYear)

  loadYears()

  $scope.CheckYears = (value, clicked) ->
    if clicked
      $('.chartcontainer' + value).show()
      if $scope.myYear.indexOf(value) == -1
        $scope.myYear.push(value)
        container = 'chartcontainer' + value
        $scope.load(value, container)
    else
      $('.chartcontainer' + value).hide()
    return
]
