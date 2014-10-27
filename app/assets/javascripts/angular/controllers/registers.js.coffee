@RegistersCtrl = ['$scope', '$q', 'Register', 'Article', 'Counterparty', ($scope, $q, Register, Article, Counterparty) ->

  $scope.newRegister = {}

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
