angular.module('accounting.services').factory 'Counterparty', ['$resource', ($resource) ->
  $resource('/counterparties/:id', {id: '@id'}, {update: {method: 'PUT'}})
]

angular.module('accounting.services').factory 'Article', ['$resource', ($resource) ->
  $resource('/articles/:id', {id: '@id'}, {update: {method: 'PUT'}})
]

angular.module('accounting.services').factory 'Register', ['$resource', ($resource) ->
  $resource('/registers/:id', {id: '@id'}, {update: {method: 'PUT'}})
]

angular.module('accounting.services').factory 'Report', ['$resource', ($resource) ->
  $resource('/reports')
]
