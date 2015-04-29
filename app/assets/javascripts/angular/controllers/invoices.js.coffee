@InvoicesCtrl = ['$scope', 'Hours', 'Counterparty', '$translate', ($scope, Hours, Counterparty, $translate) ->
  $scope.params = {
    month: moment().format('MM/YYYY')
  }

  $scope.currentMonth = moment().format('MM')

  $scope.currentYear = moment().format('YYYY')

  $scope.months = $translate.instant('fullMonthsName').split(',')

  $scope.customers = Counterparty.query
    scope: 'active'
    group: 'Customer'
    () ->
      $('select.custumers').select2({width: '179px', minimumResultsForSearch: '5'})

  $scope.createInvoise = ->
    $.each $scope.customers, ->
      if @id == parseInt($scope.params.customer_id)
        $scope.customer = @
    $scope.hours = Hours.query
      month: $scope.params.month
      customer_id: $scope.params.customer_id
      () ->
        $scope.total = null
        if $scope.hours.length > 1
          $.each $scope.hours, ->
            $scope.total = $scope.total + (@hours * $scope.customer.value_payment)
        else
          $scope.total = $scope.total + ($scope.hours[0].hours * $scope.customer.value_payment) if $scope.hours.length > 0
]
