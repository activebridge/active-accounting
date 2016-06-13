@InvoicesCtrl = ['$scope', '$http', 'Hours', 'Counterparty', 'ClientInvoices', '$translate', '$routeParams', 'clientActInvoiceDecorator', '$rootScope', 'Signatures', ($scope, $http, Hours, Counterparty, ClientInvoices, $translate, $routeParams, clientActInvoiceDecorator, $rootScope, Signatures) ->
  clientActInvoiceDecorator($scope)

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

  $scope.changeSelect = ->
    $scope.currentCustomer = _.find $scope.customers, (customer) ->
      parseInt($scope.params.customer_id) == customer.id
    $scope.invoices = ClientInvoices.query(
      customer_id: $scope.currentCustomer.id
      () ->
        $scope.showCurrentInvoice = false
        $scope.infoInvoiceEmpty = _.isEmpty $scope.invoices
    )

  displayInvoice = (id) ->
    $scope.customer = $scope.currentCustomer
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

    $scope.idShowInvoice = id
    $scope.showCurrentInvoice = true
    $scope.infoInvoiceEmpty = false

  $scope.createInvoice = ->
    ClientInvoices.save $scope.params,
      (response) ->
        displayInvoice(response.id)
        $scope.invoices = ClientInvoices.query(customer_id: $scope.currentCustomer.id)
      (response) ->
        $scope.errorResponse(response)
        response

  $scope.updateInvoice = (id, data)->
    ClientInvoices.update(id: id, {invoice: data}
      (response) ->
        invoice = _.find $scope.invoices, (invoice) -> invoice.id == id
        index = $scope.invoices.indexOf(invoice)
        $scope.invoices[index] = response
      (response) ->
        $scope.errorResponse(response)
        response
    )

  $scope.showInvoice = (id) ->
    ClientInvoices.get(id: id, month: $scope.params.month,
      () ->
        displayInvoice(id)
      (response) ->
        $scope.errorResponse(response)
    )

  $scope.delete = (id) ->
    if confirm($translate.instant('sure'))
      ClientInvoices.delete
        id: id
      , (success) ->
        $scope.invoices = ClientInvoices.query(customer_id: $scope.currentCustomer.id)

  $scope.hideCurrentInvoice = ->
    $scope.showCurrentInvoice = false

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

  $scope.showCreateInvoiceButton = () ->
    return $scope.invoices && $scope.params.customer_id && $scope.invoices.length >= 0

  $scope.showInvoicesRegistry = () ->
    return $scope.invoices && !$scope.showCurrentInvoice && $scope.invoices.length > 0

  $rootScope.getSignatures = ->
    getSignatures()

  getSignatures = ->
    $scope.signatures = Signatures.query()
  getSignatures()
]
