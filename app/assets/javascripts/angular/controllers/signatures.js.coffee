@SignaturesCtrl = ['$scope', '$q', 'Signatures', '$translate', '$rootScope', ($scope, $q, Signatures, $translate, $rootScope) ->

  $scope.currentSignature = {}

  errorMessage = (arrayMessage) ->
    _.map arrayMessage, (message) ->
      $translate.instant('errors.' + message)

  errorResponse = (errors) ->
    _.map errors, (array, key) ->
      $translate.instant('signatures.' + key) + ': ' + errorMessage(array).join(', ')

  $scope.updateSignature = (id, data) ->
    console.log id, data, 'update', $scope.currentSignature
    Signatures.update( id: $scope.currentSignature.id, {signature: $scope.currentSignature}
      (response) ->
        console.log response
        $rootScope.getSignatures()
        $scope.currentSignature = {}
      (response) ->
        alert errorResponse(response.data.error).join(', ')
    )

  $scope.createSignature = (id, data) ->
    Signatures.save( id: id, {signature: $scope.currentSignature}
      (response) ->
        $rootScope.getSignatures()
        $scope.getCacheSignature()
        $scope.currentSignature = {}
      (response) ->
        alert errorResponse(response.data.error).join(', ')
    )

  $scope.editSignature = (signature) ->
    $scope.cacheSignature = $scope.currentSignature
    $scope.currentSignature = signature

  $scope.getCacheSignature = ->
    $scope.currentSignature = $scope.cacheSignature

  $scope.deleteSignature = (id) ->
    if confirm($translate.instant('sure'))
      Signatures.delete
        id: id
      , (success) ->
          $rootScope.getSignatures()
          $scope.getCacheSignature() if $scope.currentSignature.id == id
]
