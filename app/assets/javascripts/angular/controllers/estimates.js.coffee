@EstimatesCtrl = ['$scope', '$q', '$translate', 'Estimate', 'Counterparty', 'registerDecorator', ($scope, $q , $translate, Estimate, Counterparty, registerDecorator) ->
  registerDecorator($scope)

  $scope.newEstimate = {}
  $scope.newEstimate.errors = {}

  curr_date = new Date()
  $scope.currentYear = curr_date.getFullYear()
  $scope.currentMonth = curr_date.getMonth() + 1

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

  $scope.LoadHours = ->
    Estimate.total_hours (response) ->
      $scope.hoursByMonths = $scope.addBlankValues(response)

  $scope.changeMonth = (value) ->
    if value != $scope.selectedMonth
      $scope.selectedMonth = value
      $scope.estimates = Estimate.query(month: value + '/' + $scope.currentYear, type: 'vendor')
  $scope.changeMonth($scope.currentMonth)
  $scope.LoadHours()

  $scope.months = $translate.instant('fullMonthsName').split(',')

  $scope.add = ->
    estimate = Estimate.save($scope.newEstimate,
      () ->
        if parseInt(estimate.month.slice(0,2)) == $scope.selectedMonth
          $scope.estimates.unshift(estimate)
        $scope.newEstimate = {}
        $('select.estimate').select2('val', '')
        $scope.LoadHours()
      (response) ->
        $scope.newEstimate.errors = response.data.error
    )

  $scope.customers = Estimate.customers
    scope: 'active'
    () ->
      $('select.estimate').select2({width: '200px'})

  $scope.delete = (estimate_id, index) ->
    if confirm('Впевнений?')
      Estimate.delete
        id: estimate_id
      , (success) ->
        $scope.estimates.splice(index,1)
        $scope.LoadHours()
        return
  $scope.setNumeric = ->
    $('.number').numeric
      negative: false
      decimal: false
    $('.number').attr('maxlength', '3')
  $scope.setNumeric()

  $('#estimates_form').validate
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

  $scope.update = (estimate_id, data) ->
    d = $q.defer()
    estimate = Estimate.update( id: estimate_id, {estimate: { hours: data.hours } }
      (response) ->
        d.resolve()
        $scope.LoadHours()
      (response) ->
        d.resolve response.data.errors['hours'][0]
    )
    return d.promise
]
