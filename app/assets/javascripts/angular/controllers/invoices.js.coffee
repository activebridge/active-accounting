@InvoicesCtrl = ['$scope', 'Hours', 'Counterparty', '$translate', '$routeParams', ($scope, Hours, Counterparty, $translate, $routeParams) ->

  $scope.params = {
    month: moment().format('MM/YYYY')
  }

  $scope.currentMonth = moment().format('MM')

  $scope.currentYear = moment().format('YYYY')

  $scope.months = $translate.instant('fullMonthsName').split(',')

  $scope.vendors = Counterparty.query
    scope: 'active'
    group: 'Vendor'

  $scope.customers = Counterparty.query
    scope: 'active'
    group: 'Customer'
    () ->
      unless $.isEmptyObject($routeParams)
        $scope.params = $routeParams
        $scope.createInvoice()

  $scope.createInvoice = ->
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

  $scope.setSelect2 = ->
    $('select.custumers').select2({width: '181px', minimumResultsForSearch: '5'})
    $('#month_' + parseInt($scope.params.month.slice(0,2))).addClass('active')
    return

  $scope.currentTab = 'invoice'
  $scope.currentType = 'customer'

  $scope.changeGroup = (value) ->
    $scope.currentTab = value

  $scope.changeType = (value) ->
    $scope.currentType = value
]
