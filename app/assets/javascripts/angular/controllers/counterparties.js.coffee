@CounterpartiesCtrl = ['$scope', '$q', '$timeout', 'Counterparty', ($scope, $q, $timeout, Counterparty) ->
  $scope.load = ->
    $scope.activeCounterparties = Counterparty.query(scope: 'active')
    $scope.inactiveCounterparties = Counterparty.query(scope: 'inactive')

  $('#start_date').datepicker
    dateFormat: 'dd-mm-yy'

  $scope.openDatepicker = ->
    $('.start_date').datepicker({ dateFormat: "dd-mm-yy" }).focus()
    return

  $scope.add = ->
    counterparty = Counterparty.save($scope.newCounterparty,
      () ->
        $scope.activeCounterparties.push(counterparty)
        $scope.newCounterparty = {}
    )

  $scope.delete = (counterparty_id) ->
    if confirm('Впевнений?')
      Counterparty.delete
        id: counterparty_id
      , (success) ->
        $scope.load()
        return

  $scope.update = (counterparty_id, data) ->
    d = $q.defer()
    Counterparty.update( id: counterparty_id, {counterparty: data}
      () ->
        d.resolve()
        $scope.load()
      (response) ->
        d.resolve response.data.errors['data'][0]
    )
    return d.promise

  $scope.load()
]
