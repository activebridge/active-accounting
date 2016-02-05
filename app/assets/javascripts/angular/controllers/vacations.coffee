@VacationsCtrl = ['$scope', '$translate', 'uiCalendarConfig', 'Vacations', ($scope, $translate, uiCalendarConfig, Vacations) ->

  $scope.newVacation = {}
  $scope.currentDate = moment()
  $scope.currentYear = $scope.currentDate.year()
  $scope.months = $translate.instant('fullMonthsName').split(',')
  $scope.currentMonth = $scope.months[$scope.currentDate.month()]

  $scope.vacationsSource =
    backgroundColor: 'green'
    color: 'green'
    events: []

  $scope.load = ->
    $scope.daysLeft = 21
    $scope.daysUsed = $scope.daysReserved = 0
    $scope.vacations = Vacations.query(year: $scope.currentYear)

    $scope.vacations.$promise.then ->
      for key in $scope.vacations
        $scope.vacationsSource.events.push
          start: key.start
          end: key.ending
          stick: true
        days = moment(key.ending).diff(key.start, 'days')
        if $scope.currentDate.isAfter(key.ending)
          $scope.daysUsed += days
        else
          $scope.daysReserved += days

      $scope.daysLeft -= $scope.daysReserved + $scope.daysUsed
      return

  $scope.uiConfig = calendar:
    selectable: true
    selectOverlap: false
    lang: $translate.use()
    header:
      left: ''
      center: ''
      right: ''
    select: (start, end) ->
      days = end.diff(start, 'days')
      if $scope.currentDate.isBefore(start) and $scope.daysLeft >= days
        $scope.vacationsSource.events.push
          start: start.format()
          end: end.format()
          stick: true
        $scope.newVacation =
          start: start.format()
          ending: end.format()
        $scope.daysReserved += days
        $scope.daysLeft -= days
        $scope.add()
      return

  $scope.changeYear = (direction) ->
    $scope.vacationsSource.events = []
    uiCalendarConfig.calendars.vacationCalendar.fullCalendar('removeEvents')
    uiCalendarConfig.calendars.vacationCalendar.fullCalendar(direction)
    $scope.currentYear = uiCalendarConfig.calendars.vacationCalendar.fullCalendar('getDate').year()
    $scope.load()
    return

  $scope.changeMonth = (direction) ->
    monthIndex = uiCalendarConfig.calendars.vacationCalendar.fullCalendar('getDate').month()
    if direction == 'prev' and monthIndex > 0
      uiCalendarConfig.calendars.vacationCalendar.fullCalendar(direction)
      $scope.currentMonth = $scope.months[monthIndex-1]
    else if direction == 'next' and monthIndex < 11
      uiCalendarConfig.calendars.vacationCalendar.fullCalendar(direction)
      $scope.currentMonth = $scope.months[monthIndex+1]
    return

  $scope.showDeleteButton = (date) ->
    $scope.currentDate.isBefore(date)

  $scope.add = ->
    vacation = Vacations.save($scope.newVacation,
      () ->
        $scope.vacations.push(vacation)
        $scope.newVacation = {}
    )

  $scope.delete = (vacation, index) ->
    if confirm('Впевнений?')
      Vacations.delete
        id: vacation.id
      , (success) ->
        days = moment(vacation.ending).diff(vacation.start, 'days')
        $scope.daysLeft += days
        $scope.daysReserved -= days
        $scope.vacationsSource.events.splice(index, 1)
        $scope.vacations.splice(index, 1)
      return

  $scope.eventSources = [$scope.vacationsSource]
  $scope.load()
]