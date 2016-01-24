angular.module('accounting.services').factory 'Counterparty', ['$resource', ($resource) ->
  $resource '/counterparties/:id/:action',
    id: '@id'
  , payments:
    method: 'GET',
    params:
      action: 'payments'
    isArray: true
  , customers:
    method: 'GET',
    params:
      action: 'customers'
    isArray: true
  , update:
    method: 'PUT'
]

angular.module('accounting.services').factory 'Tax', ['$resource', ($resource) ->
  $resource '/tax/',
    id: '@id'
  , edit:
    url: '/tax/edit'
    method: 'GET',
    isArray: false
  , update:
    method: 'PUT'
]

angular.module('accounting.services').factory 'Article', ['$resource', ($resource) ->
  $resource('/articles/:id', {id: '@id'}, {update: {method: 'PUT'}})
]

angular.module('accounting.services').factory 'Register', ['$resource', ($resource) ->
  $resource '/registers/:id/:action',
    id: '@id'
  , update:
    method: 'PUT'
  , sumaryProfit:
    method: 'GET'
    params:
      action: 'sumary_profit'
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
  , total_hours:
    method: 'GET',
    params:
      action: 'total_hours'
    isArray: true
  , years:
    method: 'GET',
    params:
      action: 'years'
    isArray: false
  , approve_hours:
    method: 'POST',
    params:
      action: 'approve_hours'
  , update:
    method: 'PUT'
]

angular.module('accounting.services').factory 'ReportHours', ['$resource', ($resource) ->
  $resource '/report_hours/:id'
]

angular.module('accounting.services').factory 'ClientInfo', ['$resource', ($resource) ->
  $resource '/client_infos/:id',
    id: '@id'
  , update:
    method: 'PUT'
]

angular.module('accounting.services').factory 'VendorChangePassword', ['$resource', ($resource) ->
  $resource '/vendor_password_resets/:action',
    id: '@id'
  , change_password:
    method: 'POST',
    params:
      action: 'change_password'
]

angular.module('accounting.services').factory 'Holiday', ['$resource', ($resource) ->
  $resource '/holidays/:id/:action',
    id: '@id'
  , update:
    method: 'PUT'
]

angular.module('accounting.services').factory 'WorkDay', ['$resource', ($resource) ->
  $resource '/work_days/'
]

angular.module('accounting.services').factory 'VendorInfo', ['$resource', ($resource) ->
  $resource '/vendor_infos/:id',
    id: '@id'
  , update:
    method: 'PUT'
]

angular.module('accounting.services').factory 'OrderFeatures', ['$resource', ($resource) ->
  $resource '/order_features/:id',
    id: '@id'
  , update:
    method: 'PUT'
]

angular.module('accounting.services').factory 'VendorActs', ['$resource', ($resource) ->
  $resource '/vendor_acts/:id',
    id: '@id'
  , update:
    method: 'PUT'
]

angular.module('accounting.services').factory 'MissingHours', ['$resource', ($resource) ->
  $resource '/missing_hours/:id',
    id: '@id'
  , update:
    method: 'PUT'
]
