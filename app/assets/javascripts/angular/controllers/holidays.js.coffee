@HolidaysCtrl = ['$scope', '$q', 'Holiday', ($scope, $q, Holiday) ->
  $scope.newHoliday = {}
  $scope.newHoliday.errors = {}

  $scope.currentYear = moment().format('YYYY')
  $scope.yearsList = [2015..parseInt($scope.currentYear, 10)+1]

  $scope.load = ->
    $scope.holidays = Holiday.query(year: $scope.currentYear)

  $('.date').datepicker
    dateFormat: 'dd.mm'
    changeMonth: true
    beforeShow: (input, inst) ->
      inst.dpDiv.addClass 'hide-year'
      return

  $scope.setSelect2 = ->
    $('select#current_year').select2()
    return

  $scope.add = ->
    $scope.newHoliday.date += ".#{$scope.currentYear}"
    holiday = Holiday.save($scope.newHoliday,
      () ->
        if holiday.date.slice(6) == $scope.currentYear
          $scope.holidays.push(holiday)
          $scope.newHoliday = {}
      , (response) ->
        $scope.newHoliday.errors = response.data.error
    )

  $scope.delete = (holiday_id, index) ->
    if confirm('Впевнений?')
      Holiday.delete
        id: holiday_id
      , (success) ->
        $scope.holidays.splice(index,1)
        return

  $scope.update = (holiday_id, data) ->
    d = $q.defer()
    holiday = Holiday.update( id: holiday_id, {holiday: data}
      (response) ->
        d.resolve()
      (response) ->
        d.resolve response.data.errors['name'][0]
    )
    return d.promise

  $scope.setDatepicker = ->
    $('.date').datepicker
      yearRange: "#{$scope.currentYear}:#{$scope.currentYear}"
      changeMonth: true
    return

  $scope.changeYear = ->
    $scope.load()
    return

  $scope.setDatepicker()
  $scope.load()
]
