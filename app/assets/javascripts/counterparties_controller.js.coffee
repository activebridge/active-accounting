app = angular.module('Counterparties', ['ngResource'])

app.factory 'Counterparty', ['$resource', ($resource) ->
  $resource('/counterparties/:id', {id: '@id'})
]

@CounterpartiesCtrl = ['$scope', 'Counterparty', ($scope, Counterparty) ->
  $scope.counterparties = Counterparty.query()
]
