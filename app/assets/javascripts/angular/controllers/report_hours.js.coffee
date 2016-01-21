@ReportHoursCtrl = ['$scope', '$q', '$translate', '$modal', 'Hours', 'Counterparty', 'ReportHours', 'registerDecorator', 'hourDecorator', 'Holiday', 'WorkDay', ($scope, $q , $translate, $modal, Hours, Counterparty, ReportHours, registerDecorator, hourDecorator, Holiday, WorkDay) ->
  registerDecorator($scope)
  hourDecorator($scope)
  $scope.hours = {}
  $scope.newHour = {}
  $scope.newHour.errors = {}
  $scope.filter = {}
  $scope.filter.data = {}

  curr_date = new Date()
  $scope.currentYear = curr_date.getFullYear()
  $scope.currentMonth = curr_date.getMonth() + 1
  $scope.currentDate = curr_date.getDate()
  $scope.months = $translate.instant('fullMonthsName').split(',')
  $scope.year = $scope.currentYear
  $scope.newHour.month = moment().format('MM/YYYY')

  loadYears = ->
    Hours.years (response) ->
      $scope.years = response['years']
  loadYears()

  $scope.misingHoursModal = (url) ->
    $scope.missingHours = $modal(scope: $scope, template: url, show: false)
    $scope.missingHours.$promise.then $scope.missingHours.show

  $scope.LoadHours = (year, options = {}) ->
    Hours.total_hours
      year: $.trim(year)
      (response) ->
        $scope.hoursByMonths = $scope.addBlankValues(response)
        $scope.changeMonth($scope.selectedMonth, options = { update: true }) unless options.firstLoad

  $scope.LoadCalendar()
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
        $scope.LoadHours($scope.year)
      (response) ->
        d.resolve response.data.errors['hours'][0]
    )
    return d.promise

  $scope.setSelect2 = ->
    $('select.hours').select2()
    $scope.newHour.vendor_id = $scope.vendor_id
    $scope.newHour.customer_id = $scope.customer_id
    $('select.year-select').select2({ 'minimumResultsForSearch': 5 })
    return

  $scope.add = ->
    hour = ReportHours.save($scope.newHour,
      () ->
        if parseInt(hour.month.slice(0,2)) == $scope.selectedMonth
          $scope.hours.unshift(hour)
        $scope.newHour.hours = ''
        loadYears()
        $scope.LoadHours($scope.year)
        $scope.newHour.month = moment().format('MM/YYYY')
        $scope.newHour.errors = []
      (response) ->
        $scope.newHour.errors = response.data.error
    )

  $scope.customers = Counterparty.customers(scope: 'active')
  $scope.vendors = Counterparty.query
    scope: 'active'
    group: 'Vendor'

  $scope.approveHours = ->
    Hours.approve_hours (response) ->
      if response.status is 'OK'
        $scope.showInfoApproveHours = true
        $scope.countRecordsApproveHours = response.count_records
        setTimeout (->
          $scope.$apply ->
            $scope.showInfoApproveHours = false
            return
          return
        ), 3000
        $scope.LoadHours($scope.year) if response.count_records > 0

  $scope.delete = (hours_id, index) ->
    if confirm('Впевнений?')
      Hours.delete
        id: hours_id
      , (success) ->
        loadYears()
        $scope.hours.splice(index,1)
        $scope.LoadHours($scope.year)
        return

  $scope.filter.clear = ->
    $('select.search').select2('val', '')
    $scope.filter.data = {}

  $scope.filter.show = ->
    $scope.filter.active = !($scope.filter.active)
    $scope.filter.clear()

  $scope.filter.fetchHours = () ->
    $scope.hours = Hours.query
      customer_id: $scope.filter.data.customer_id
      vendor_id: $scope.filter.data.vendor_id
      month: $scope.selectedMonth + '/' + $.trim($scope.year)
    return
]
