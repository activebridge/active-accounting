@ActsCtrl = ['$q', '$scope', '$http', '$translate', '$cookies', 'ClientActs', ($q, $scope, $http, $translate, $cookies, ClientActs) ->
  $scope.params = {
    month: moment().format('MM/YYYY')
  }

  $scope.changeSelect = () ->
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
    $("#generated-act").html response
    $scope.idShowAct = $('#act_id').text()
    $scope.showCurrentAct = true
    $scope.infoActEmpty = false

  errorResponse = (response) ->
    messages = ''
    lengthMessages = response.messages.length
    angular.forEach(response.messages, (v, k)->
      messages += $translate.instant(v)
      messages += ', ' if k != lengthMessages - 1 && k != 0
    )
    alert messages
    $("#generated-act").html ''

  $scope.createAct = ->
    $http.post('acts/', $scope.params).success(
      (response) ->
        displayAct(response)
        $scope.acts = ClientActs.query(customer_id: $scope.currentCustomer.id)
    ).error (response) ->
      errorResponse(response)
      response

  $scope.showAct = (id) ->
    $http.get('acts/' + id, params: $scope.params).success(
      (response) ->
        displayAct(response)
    ).error (response) ->
      errorResponse(response)

  $scope.hideCurrentAct = ->
    $scope.showCurrentAct = false

  $scope.updateAct = (id, data) ->
    d = $q.defer()
    ClientActs.update(id: id, { total_money: data, month: $scope.params.month }
      (response) ->
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

