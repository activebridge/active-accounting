@VacationsCtrl = ['$scope', '$translate', 'uiCalendarConfig', 'Vacations', ($scope, $translate, uiCalendarConfig, Vacations) ->

  $scope.newVacation = {}
  $scope.currentDate = moment()
  $scope.currentYear = $scope.currentDate.year()
  $scope.months = $translate.instant('fullMonthsName').split(',')
  $scope.currentMonth = $scope.months[$scope.currentDate.month()]

  $scope.vacationsSource =
    backgroundColor: 'green'
    color: 'green'
    years: []
    events: []

  $scope.load = ->
    $scope.daysLeft = 15
    $scope.daysUsed = $scope.daysReserved = 0
    $scope.vacations = Vacations.query(year: $scope.currentYear)
    $scope.vacations.$promise.then ->
      for key in $scope.vacations
        $scope.vacationsSource.events.push
          vacation_id: key.id
          start: key.start
          end: key.ending
          stick: true
        unless _.contains($scope.vacationsSource.years, $scope.currentYear)
          $scope.vacationsSource.years.push($scope.currentYear)
        $scope.vacationDayCount(key.start, key.ending, 1)
      return

    $scope.showVacations($scope.vacations)

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
        isWeekdays = $scope.vacationDayCount(start, end, 1)
        if isWeekdays
          $scope.newVacation =
            start: start.format()
            ending: end.format()
          $scope.vacation = Vacations.save $scope.newVacation,
            (response) ->
              $scope.vacations.push(response)
              $scope.showVacations($scope.vacations)
              $scope.newVacation = {}
              response
          $scope.vacation.$promise.then ->
            $scope.vacationsSource.events.push
              vacation_id: $scope.vacation.id
              start: start.format()
              end: end.format()
              stick: true
      return

  $scope.changeYear = (direction) ->
    unless _.contains($scope.vacationsSource.years, $scope.currentYear)
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
    $scope.showVacations($scope.vacations)
    return

  $scope.showDeleteButton = (date) ->
    $scope.currentDate.isBefore(date)

  $scope.vacationDayCount = (start, end, day_count) ->
    end = moment(end).subtract(1, 'day')
    dates = moment.range(start, end)
    weekdays = no
    dates.by 'days', (date) ->
      if date.day() > 0 and date.day() < 6
        weekdays = yes if not weekdays
        if $scope.currentDate.isBefore(start)
          $scope.daysReserved += day_count
        else
          $scope.daysUsed += day_count
        $scope.daysLeft -= day_count
    return weekdays

  $scope.showVacations = (vacations) ->
    $scope.visibleVacations = []
    monthIndex = _.indexOf($scope.months, $scope.currentMonth)
    vacations.$promise.then ->
      for vacation in vacations
        if parseInt(vacation.start.slice(5,7)) == monthIndex + 1
          $scope.visibleVacations.push(vacation)
    $scope.visibleVacations

  $scope.delete = (vacation, index) ->
    if confirm('Впевнений?')
      Vacations.delete
        id: vacation.id
      , (success) ->
        $scope.vacationDayCount(vacation.start, vacation.ending, -1)
        _.find($scope.vacationsSource.events, (event) ->
          if event.vacation_id == vacation.id
            id = _.indexOf($scope.vacationsSource.events, event)
            $scope.vacationsSource.events.splice(id, 1)
        )
        id = _.indexOf($scope.vacations, vacation)
        $scope.vacations.splice(id, 1)
        $scope.showVacations($scope.vacations)
      return

  $scope.eventSources = [$scope.vacationsSource]
  $scope.load()
]
