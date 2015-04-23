@ClientInfosCtrl = ['$scope', '$q', 'ClientInfo', ($scope, $q, ClientInfo) ->

  $scope.update = (clientInfo) ->
    d = $q.defer()
    ClientInfo.update( id: clientInfo.id, {client_info: clientInfo}
      (response) ->
        d.resolve()
        $scope.message = response
        setTimeout (->
          $scope.$apply ->
            $scope.message = undefined
            return
          return
        ), 4000
      (response) ->
        d.resolve response.clientInfo.errors['clientInfo'][0]
    )
    return d.promise

  $scope.setNumeric = ->
    $('.number').numeric
      negative: false
      decimal: false
]
