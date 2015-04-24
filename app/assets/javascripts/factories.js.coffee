angular.module('accounting.services').factory 'Counterparty', ['$resource', ($resource) ->
  $resource '/counterparties/:id/:action',
    id: '@id'
  , payments:
    method: 'GET',
    params:
      action: 'payments'
    isArray: true
  , update:
    method: 'PUT'
]

angular.module('accounting.services').factory 'Article', ['$resource', ($resource) ->
  $resource('/articles/:id', {id: '@id'}, {update: {method: 'PUT'}})
]

angular.module('accounting.services').factory 'Register', ['$resource', ($resource) ->
  $resource('/registers/:id', {id: '@id'}, {update: {method: 'PUT'}})
]

angular.module('accounting.services').factory 'PlanRegister', ['$resource', ($resource) ->
  $resource('/plan_registers/:id', {id: '@id'}, {update: {method: 'PUT'}})
]

angular.module('accounting.services').factory 'Report', ['$resource', ($resource) ->
  $resource '/reports/:id/:action',
    id: '@id'
  , years:
    method: 'GET',
    params:
      action: 'years'
    isArray: false
]

angular.module('accounting.services').factory 'Chart', ['$resource', ($resource) ->
  $resource '/charts/:id/:action',
    id: '@id'
  , years:
    method: 'GET',
    params:
      action: 'years'
    isArray: false
]

angular.module('accounting.services').factory 'Invitation', ['$resource', ($resource) ->
  $resource '/invitations/:id'
]

angular.module('accounting.services').factory 'Hours', ['$resource', ($resource) ->
  $resource '/hours/:id/:action',
    id: '@id'
  , customers:
    method: 'GET',
    params:
      action: 'customers'
    isArray: true
  , total_hours:
    method: 'GET',
    params:
      action: 'total_hours'
    isArray: true
  , update:
    method: 'PUT'
]

angular.module('accounting.services').factory 'ClientInfo', ['$resource', ($resource) ->
  $resource '/client_infos/:id',
    id: '@id'
  , update:
    method: 'PUT'
]
