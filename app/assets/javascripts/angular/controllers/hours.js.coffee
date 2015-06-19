@HoursCtrl = ['$scope', '$q', '$translate', 'Hours', 'Counterparty', 'registerDecorator', 'hourDecorator', 'Holiday', 'WorkDay', ($scope, $q , $translate, Hours, Counterparty, registerDecorator, hourDecorator, Holiday, WorkDay) ->
  registerDecorator($scope)
  hourDecorator($scope)
  $scope.current_vendor = gon.current_vendor
  $scope.current_vendor.approvehoursStatus = $scope.current_vendor.approve_hours

  $scope.newHour = {}
  $scope.newHour.errors = {}

  curr_date = new Date()
  $scope.currentYear = curr_date.getFullYear()
  $scope.currentMonth = curr_date.getMonth() + 1
  $scope.currentDate = curr_date.getDate()
  $scope.newHour.month = moment().format('MM/YYYY')

  $scope.LoadHours = ->
    Hours.total_hours
      type: 'vendor'
      (response) ->
        $scope.hoursByMonths = $scope.addBlankValues(response)

  $scope.updateApproveHours = ->
    Counterparty.update(id: $scope.current_vendor.id, counterparty: { approve_hours: $scope.current_vendor.approvehoursStatus })

  $scope.changeMonth($scope.currentMonth)
  $scope.LoadHours()

  $scope.months = $translate.instant('fullMonthsName').split(',')

  $scope.add = ->
    hour = Hours.save($scope.newHour,
      () ->
        if parseInt(hour.month.slice(0,2)) == $scope.selectedMonth
          $scope.hours.unshift(hour)
        $scope.newHour.hours = ''
        $scope.LoadHours()
        $scope.newHour.month = moment().format('MM/YYYY')
      (response) ->
        $scope.newHour.errors = response.data.error
    )

  $scope.customers = Counterparty.customers(scope: 'active')

  $scope.setSelect2 = ->
    $('select.hours').select2()
    $scope.newHour.customer_id = $scope.current_vendor.customer_id

  $scope.delete = (hours_id, index) ->
    if confirm('Впевнений?')
      Hours.delete
        id: hours_id
      , (success) ->
        $scope.hours.splice(index,1)
        $scope.LoadHours()
        return
]
