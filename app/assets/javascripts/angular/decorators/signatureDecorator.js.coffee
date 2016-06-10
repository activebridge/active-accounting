angular.module('accounting.services').factory 'signatureDecorator', ['Signatures', (Signatures) ->
  ($scope) ->
    $scope.signatures = Signatures.query()
]
