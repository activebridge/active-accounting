@VacationsCtrl = ['$scope', '$translate', ($scope, $translate) ->

  $scope.vacations = {
    backgroundColor: 'green'
    color: 'green'
    events: [
      {
        start: '2016-02-01'
        end: '2016-02-03'
      }
    ]
  }

  $scope.uiConfig = calendar:
    selectable: true
    selectOverlap: false
    lang: $translate.use()
    header:
      left: 'prev'
      center: 'title'
      right: 'next'
    select: (start, end) ->
      $scope.vacations.events.push
        start: start.format()
        end: end.format()
      return

  $scope.eventSources = [$scope.vacations]
]
