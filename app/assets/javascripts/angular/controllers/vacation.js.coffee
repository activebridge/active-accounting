@VacationCtrl = ['$scope', '$q', '$translate', ($scope, $q , $translate) ->
  current_date = new Date()
  $scope.currentYear = current_date.getFullYear()
  $scope.currentMonth = current_date.getMonth() + 1
  $scope.days = _.range(1, new Date($scope.currentYear, $scope.currentMonth, 0).getDate() + 1)
  $scope.weekDay = new Date($scope.currentYear, $scope.currentMonth-1, 1).getDay()
  $scope.weekDay = 7 if $scope.weekDay == 0
  $scope.test = _.range(1, $scope.weekDay, 0)
  $scope.daysNames = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Нд']
  $scope.vacationDays = []
  $scope.months = $translate.instant('fullMonthsName').split(',')

  $scope.changeMonth = (enlarge) ->
    if enlarge
      $scope.currentMonth += 1
      $scope.currentMonth = 1 if $scope.currentMonth > 12
    else
      $scope.currentMonth -= 1
      $scope.currentMonth = 12 if $scope.currentMonth < 1

    $scope.days = _.range(1, new Date($scope.currentYear, $scope.currentMonth, 0).getDate() + 1)
    $scope.weekDay = new Date($scope.currentYear, $scope.currentMonth-1, 1).getDay()
    $scope.weekDay = 7 if $scope.weekDay == 0
    $scope.test = _.range(1, $scope.weekDay, 0)
  
  $scope.$watch 'currentYear', ->
    $scope.days = _.range(1, new Date($scope.currentYear, $scope.currentMonth, 0).getDate() + 1)
    $scope.weekDay = new Date($scope.currentYear, $scope.currentMonth-1, 1).getDay()
    $scope.weekDay = 7 if $scope.weekDay == 0
    $scope.test = _.range(1, $scope.weekDay, 0)
    return

  $scope.selectVacationDay = (day) ->
    date = new Date($scope.currentYear, $scope.currentMonth-1, day).toDateString()
    findDate = $.inArray(date, $scope.vacationDays)
    if findDate > -1
      $scope.vacationDays.splice findDate, 1
    else
      $scope.vacationDays.push date if $scope.vacationDays.length < 10

  $scope.isWeekend = (day) ->
    day = new Date($scope.currentYear, $scope.currentMonth-1, day).getDay()
    return day == 0 || day == 6

  $scope.isVacation = (day) ->
    date = new Date($scope.currentYear, $scope.currentMonth-1, day).toDateString()
    return true if $.inArray(date, $scope.vacationDays) > -1

  $scope.addVacation = ->
    # Vacation.save
]
