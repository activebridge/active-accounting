@CounterpartiesCtrl = ['$scope', '$q', 'Counterparty', ($scope, $q, Counterparty) ->
  $scope.counterparties = Counterparty.query()

  $scope.add = ->
    counterparty = Counterparty.save($scope.newCounterparty,
      () ->
        $scope.counterparties.push(counterparty)
        $scope.newCounterparty = {}
    )

  $scope.delete = (counterparty_id) ->
    if confirm('Впевнений?')
      Counterparty.delete
        id: counterparty_id
      , (success) ->
        $scope.counterparties = Counterparty.query()
        return

  $scope.update = (counterparty_id, name) ->
    d = $q.defer()
    Counterparty.update( id: counterparty_id, {counterparty: {name: name}}
      () ->
        d.resolve()
      (response) ->
        d.resolve response.data.errors['name'][0]
    )
    return d.promise

]
