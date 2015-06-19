@ReportHoursCtrl = ['$scope', '$q', '$translate', 'Hours', 'registerDecorator', 'hourDecorator', 'Holiday', 'WorkDay', ($scope, $q , $translate, Hours, registerDecorator, hourDecorator, Holiday, WorkDay) ->
  registerDecorator($scope)
  hourDecorator($scope)
  $scope.hours = {}

  curr_date = new Date()
  $scope.currentYear = curr_date.getFullYear()
  $scope.currentMonth = curr_date.getMonth() + 1
  $scope.currentDate = curr_date.getDate()
  $scope.months = $translate.instant('fullMonthsName').split(',')

  loadYears = ->
    Hours.years (response) ->
      $scope.years = response['years']
  loadYears()

  $scope.LoadHours = (year, options = {}) ->
    Hours.total_hours
      year: $.trim(year)
      (response) ->
        $scope.hoursByMonths = $scope.addBlankValues(response)
        $scope.changeMonth($scope.selectedMonth, options = { changeYear: true }) unless options.firstLoad

  $scope.LoadHours($scope.currentYear, options = { firstLoad: true })
  $scope.changeMonth($scope.currentMonth)

  $scope.sumByGroup =(array) ->
    total = 0
    $.each array, ->
      total = total + @hours
    return total

  $scope.update = (hour_id, data) ->
    d = $q.defer()
    Hours.update( id: hour_id, {hour: { hours: data.hours } }
      (response) ->
        d.resolve()
        $scope.changeMonth()
      (response) ->
        d.resolve response.data.errors['hours'][0]
    )
    return d.promise

  $scope.setSelect2 = ->
    $('select.year-select').select2({ 'minimumResultsForSearch': 5 })
    return
]
