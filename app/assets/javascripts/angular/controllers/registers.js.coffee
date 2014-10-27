@RegistersCtrl = ['$scope', '$q', 'Register', 'Article', 'Counterparty', ($scope, $q, Register, Article, Counterparty) ->

  $scope.newRegister = {}
  $scope.newRegister.errors = {}

  $scope.registers = Register.query()
  $scope.articles = Article.query()
  $scope.counterparties = Counterparty.query()
  $('#date').datepicker
    dateFormat: 'dd-mm-yy',
    onSelect: (date, obj) ->
      $scope.newRegister.date = date

  $scope.add = ->
    register = Register.save($scope.newRegister,
      () ->
        $scope.registers.push(register)
        $scope.newRegister = {}
      , (response) ->
        $scope.newRegister.errors = response.data.errors
    )

  $scope.delete = (register_id) ->
    if confirm('Впевнений?')
      Register.delete
        id: register_id
      , (success) ->
        $scope.registers = Register.query()
        return

  $scope.update = (register_id, field, value) ->
    d = $q.defer()
    params = {}
    params[field] = value
    Register.update( id: register_id, {register: params}
      () ->
        d.resolve()
      (response) ->
        d.resolve response.data.errors[field][0]
    )
    return d.promise

]
