@HoursCtrl = ['$scope', '$q', '$translate', 'Hours', 'Counterparty', 'registerDecorator', 'hourDecorator', 'Holiday', 'WorkDay', ($scope, $q , $translate, Hours, Counterparty, registerDecorator, hourDecorator, Holiday, WorkDay) ->
  registerDecorator($scope)
  hourDecorator($scope)
  $scope.current_vendor = gon.current_counterparty
  $scope.current_vendor.approvehoursStatus = $scope.current_vendor.approve_hours

  $scope.newHour = {}
  $scope.newHour.errors = {}
  curr_date = new Date()
  $scope.currentYear = curr_date.getFullYear()
  $scope.currentMonth = curr_date.getMonth() + 1
  $scope.currentDate = curr_date.getDate()
  $scope.newHour.month = moment().format('MM/YYYY')
  $scope.customers = Counterparty.customers(scope: 'active')
  $scope.months = $translate.instant('fullMonthsName').split(',')
  $scope.changeMonth($scope.currentMonth, options = {type: "vendor"})

  $scope.loadHours = ->
    Hours.total_hours
      type: 'vendor'
      (response) ->
        $scope.hoursByMonths = $scope.addBlankValues(response)

  $scope.$watch 'workingDays', (value) ->
    $scope.newHour.hours = $scope.getWorkingHours()

  init = ->
    $scope.LoadCalendar()
    $scope.loadHours()
  init()

  $scope.updateApproveHours = ->
    Counterparty.update(id: $scope.current_vendor.id, counterparty: { approve_hours: $scope.current_vendor.approvehoursStatus })

  $scope.add = ->
    hour = Hours.save($scope.newHour,
      () ->
        if parseInt(hour.month.slice(0,2)) == $scope.selectedMonth
          $scope.hours.unshift(hour)
        $scope.loadHours()
        $scope.newHour.month = moment().format('MM/YYYY')
        $scope.newHour.errors = []
      (response) ->
        $scope.newHour.errors = response.data.error
    )

  $scope.setSelect2 = ->
    $('select.hours').select2()
    $scope.newHour.customer_id = $scope.current_vendor.customer_id

  $scope.delete = (hours_id, index) ->
    if confirm('Впевнений?')
      Hours.delete
        id: hours_id
      , (success) ->
        $scope.hours.splice(index,1)
        $scope.loadHours()
        return

  $scope.updateHours = (hour_id, data) ->
    d = $q.defer()
    Hours.update( id: hour_id, {hour: { hours: data.hours } }
      (response) ->
        d.resolve()
        $scope.loadHours()
      (response) ->
        d.resolve response.data.errors['hours'][0]
    )
    return d.promise
]
