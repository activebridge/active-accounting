@HoursCtrl = ['$scope', '$q', '$translate', 'Hours', 'Counterparty', 'registerDecorator', ($scope, $q , $translate, Hours, Counterparty, registerDecorator) ->
  registerDecorator($scope)

  $scope.newHour = {}
  $scope.newHour.errors = {}

  curr_date = new Date()
  $scope.currentYear = curr_date.getFullYear()
  $scope.currentMonth = curr_date.getMonth() + 1
  $scope.newHour.month = moment().format('MM/YYYY')

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
          array.push({ "month":i+1, "total_hours":0 })
        i++
      array.sort (a, b) ->
        if a.month > b.month
          return 1
        if a.month < b.month
          return -1
        0
    return array

  $scope.default_customer = Hours.default_customer()

  $scope.LoadHours = ->
    Hours.total_hours (response) ->
      $scope.hoursByMonths = $scope.addBlankValues(response)

  $scope.changeMonth = (value) ->
    if value != $scope.selectedMonth
      $scope.selectedMonth = value
      $scope.hours = Hours.query(month: value + '/' + $scope.currentYear, type: 'vendor')
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

  $scope.customers = Hours.customers(scope: 'active')

  $scope.delete = (hours_id, index) ->
    if confirm('Впевнений?')
      Hours.delete
        id: hours_id
      , (success) ->
        $scope.hours.splice(index,1)
        $scope.LoadHours()
        return
  $scope.setNumeric = ->
    $('.number').numeric
      negative: false
      decimal: false
    $('.number').attr('maxlength', '3')
  $scope.setNumeric()

  $('#hours_form').validate
    errorElement: 'div'
    errorPlacement: (error, element) ->
      error.insertBefore element
      return
    rules:
      'hours': required: true
      'month': required: true
    messages:
      'hours': 'Cant be blank'
      'month': 'Cant be blank'

  $scope.update = (hour_id, data) ->
    d = $q.defer()
    Hours.update( id: hour_id, {hour: { hours: data.hours } }
      (response) ->
        d.resolve()
        $scope.LoadHours()
      (response) ->
        d.resolve response.data.errors['hours'][0]
    )
    return d.promise

  $scope.setSelect2 = ->
    $('select.hours').select2()
    $scope.newHour.customer_id = $scope.default_customer.id
]
