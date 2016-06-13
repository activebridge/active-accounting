@ActsCtrl = ['$q', '$scope', '$http', '$translate', '$cookies', 'ClientActs', 'clientActInvoiceDecorator', ($q, $scope, $http, $translate, $cookies, ClientActs, clientActInvoiceDecorator) ->
  clientActInvoiceDecorator($scope)
  $scope.params = {
    month: moment().format('MM/YYYY')
  }

  $scope.changeSelect = ->
    $scope.currentCustomer = _.find $scope.customers, (customer) ->
      parseInt($scope.params.customer_id) == customer.id
    $scope.acts = ClientActs.query(
      customer_id: $scope.currentCustomer.id
      () ->
        $("#generated-act").html ''
        $scope.showCurrentAct = false
        $scope.infoActEmpty = _.isEmpty $scope.acts
    )

  displayAct = (response) ->
    $("#generated-act").html response.convert
    $scope.idShowAct = $('#act_id').text()
    $scope.showCurrentAct = true
    $scope.infoActEmpty = false

  $scope.createAct = ->
    ClientActs.save $scope.params,
      (response) ->
        $scope.acts = ClientActs.query(customer_id: $scope.currentCustomer.id)
        $scope.infoActEmpty = false
      (response) ->
        $scope.errorResponse(response)
        response

  $scope.showAct = (id) ->
    ClientActs.get(id: id, month: $scope.params.month,
        (response) ->
          displayAct(response)
        (response) ->
          $scope.errorResponse(response)
    )

  $scope.delete = (id) ->
    if confirm($translate.instant('sure'))
      ClientActs.delete
        id: id
      , (success) ->
        $scope.acts = ClientActs.query(customer_id: $scope.currentCustomer.id)

  $scope.hideCurrentAct = ->
    $scope.showCurrentAct = false

  $scope.updateAct = (id, data) ->
    d = $q.defer()
    ClientActs.update(id: id, { act: data }
      (response) ->
        act = _.find $scope.acts, (act) -> act.id == id
        index = $scope.acts.indexOf(act)
        $scope.acts[index] = response
        d.resolve()
      (response) ->
        d.resolve(response.data.errors)

    )
    return d.promise

  $scope.showCreateActButton = ->
    return $scope.acts && $scope.params.customer_id && $scope.acts.length >= 0

  $scope.showActsRegistry = ->
    return $scope.acts && !$scope.showCurrentAct && $scope.acts.length > 0
]

