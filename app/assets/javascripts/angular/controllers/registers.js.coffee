@RegistersCtrl = ['$scope', '$q', 'Register', ($scope, $q, Register) ->
  $scope.articles = Register.query()

  $scope.add = ->
    register = Register.save($scope.newRegister,
      () ->
        $scope.registers.push(register)
        $scope.newRegister = {}
    )

  $scope.delete = (register_id) ->
    if confirm('Впевнений?')
      Register.delete
        id: register_id
      , (success) ->
        $scope.registers = Register.query()
        return

  $scope.update = (register_id, name) ->
    d = $q.defer()
    Register.update( id: register_id, {register: {name: name}}
      () ->
        d.resolve()
      (response) ->
        d.resolve response.data.errors['name'][0]
    )
    return d.promise

]
