@ClientInfosCtrl = ['$scope', '$q', 'ClientInfo', ($scope, $q, ClientInfo) ->

  $scope.update = (clientInfo) ->
    d = $q.defer()
    ClientInfo.update( id: clientInfo.id, {client_info: clientInfo}
      (response) ->
        d.resolve()
        $('.info-update').fadeIn().fadeOut(4000)
      (response) ->
        d.resolve response.clientInfo.errors['clientInfo'][0]
    )
    return d.promise

  $scope.setNumeric = ->
    $('.number').numeric
      negative: false
      decimal: false
]
