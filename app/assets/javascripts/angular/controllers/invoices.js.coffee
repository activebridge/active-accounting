@InvoicesCtrl = ['$scope', '$http' , 'Hours', 'Counterparty', '$translate', '$routeParams', ($scope, $http, Hours, Counterparty, $translate, $routeParams) ->

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
    data = 
      month: $scope.params.month
      customer_id: $scope.params.customer_id
    $http.post('invoices/', data).success(
      (response) ->
        $scope.showCurrentInvoice($scope.params.month)
        getInvoices()
    ).error (response) ->
      errorResponse(response)

  $scope.setSelect2 = ->
    $('select.custumers').select2({width: '181px', minimumResultsForSearch: '5'})
    $('#month_' + parseInt($scope.params.month.slice(0,2))).addClass('active')
    return

  $scope.changeSelect = ->
    $scope.showInvoice = false
    $scope.showRegistry = true
    $scope.currentCustomer = _.find $scope.customers, (customer) ->
      parseInt($scope.params.customer_id) == customer.id
    getInvoices()
    $scope.showCurrentCustomers = false

  $scope.testchange = (id) ->
    $scope.currentInvoice = _.find $scope.invoices, (invoice) ->
      id == invoice.id
    $scope.currentVendor = _.find $scope.currentInvoice.vendors, (vendor) ->
      parseInt($scope.params.vendor_id[id]) == vendor.id
    $('#value-payment_' + id).text($scope.currentVendor.value_payment)
    return

  $scope.showCurrentInvoice = (month) ->
    $scope.showInvoice = true
    $scope.showRegistry = false
    $scope.params.month = month
    $.each $scope.customers, ->
      if @id == parseInt($scope.params.customer_id)
        $scope.customer = @
    $scope.hours = Hours.query
      month: month
      customer_id: $scope.params.customer_id
      () ->
        $scope.total = null
        if $scope.hours.length > 1
          $.each $scope.hours, ->
            $scope.total = $scope.total + (@hours * $scope.customer.value_payment)
        else
          $scope.total = $scope.total + ($scope.hours[0].hours * $scope.customer.value_payment) if $scope.hours.length > 0

  $scope.toggled = (open) ->
    $log.log('Dropdown is now: ', open);

  $scope.toggleDropdown = ($event) ->
    $event.preventDefault();
    $event.stopPropagation();
    $scope.status.isopen = !$scope.status.isopen;

  $scope.currentTab = 'invoice'
  $scope.currentType = 'customer'

  $scope.changeGroup = (value) ->
    $scope.currentTab = value

  $scope.changeType = (value) ->
    $scope.currentType = value

  $scope.hideCurrentInvoice = () ->
    $scope.showInvoice = false
    $scope.showRegistry = true

  errorResponse = (response) ->
    messages = ''
    lengthMessages = response.messages.length
    $.each response.messages, (k, v)->
      messages += $translate.instant(v)
      messages += ', ' if k != lengthMessages - 1 && k != 0
    alert messages
    $("#generated-act-vendor").html ''

  getInvoices = () ->
    $http.get("invoices?customer_id=#{$scope.params.customer_id}").success(
      (response) ->
        $scope.invoices = response
    )

  $scope.status = {
    isopen: false
  }
]
