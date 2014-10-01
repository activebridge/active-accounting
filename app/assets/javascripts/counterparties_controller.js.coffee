app = angular.module('Counterparties', ['ngResource'])

app.factory 'Counterparty', ['$resource', ($resource) ->
  $resource('/counterparties/:id', {id: '@id'})
]

@CounterpartiesCtrl = ['$scope', 'Counterparty', ($scope, Counterparty) ->
  $scope.counterparties = Counterparty.query()

  $scope.add = ->
    counterparty = Counterparty.save($scope.newCounterparty,
      () ->
        $scope.counterparties.push(counterparty)
    )

  $scope.delete = (counterparty_id) ->
    if confirm('Впевнений?')
      Counterparty.delete
        id: counterparty_id
      , (success) ->
        $scope.counterparties = Counterparty.query()
        return
]
