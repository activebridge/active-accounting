@CounterpartiesCtrl = ['$scope', '$q', '$timeout', 'Counterparty', ($scope, $q, $timeout, Counterparty) ->
  $scope.load = ->
    $scope.counterparties_active = Counterparty.query(status: 1)
    $scope.counterparties_no_active = Counterparty.query(status: 0)

  $('#start_date').datepicker
    dateFormat: 'dd-mm-yy'

  $scope.datepicker = () ->
    $timeout ->
      $('.editable-input').datepicker()

  $scope.add = ->
    counterparty = Counterparty.save($scope.newCounterparty,
      () ->
        $scope.counterparties_active.push(counterparty)
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
