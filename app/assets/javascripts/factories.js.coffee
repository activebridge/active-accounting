app = angular.module('ActiveAccounting', ['ngResource', 'xeditable'])

app.factory 'Counterparty', ['$resource', ($resource) ->
  $resource('/counterparties/:id', {id: '@id'}, {update: {method: 'PUT'}})
]

app.factory 'Article', ['$resource', ($resource) ->
  $resource('/articles/:id', {id: '@id'}, {update: {method: 'PUT'}})
]
