angular.module('accounting.services', [
  'ngRoute',
  'ngResource',
  'xeditable'
])

angular.module('ActiveAccounting', ['accounting.services'])
