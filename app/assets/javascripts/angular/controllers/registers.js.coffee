@RegistersCtrl = ['$scope', '$q', 'Register', 'Article', 'Counterparty', ($scope, $q, Register, Article, Counterparty) ->

  $scope.load = ->
    $scope.registers = Register.query(month: $('#month-picker').val())

  $scope.newRegister = {}
  $scope.newRegister.errors = {}

  $scope.articles = Article.query()

  $scope.counterparties = Counterparty.query()

  $('#date').datepicker
    dateFormat: 'dd-mm-yy',
    onSelect: (date, obj) ->
      $scope.newRegister.date = date

  curr_date = new Date()
  $('#month-picker').val((curr_date.getMonth()+1) + '/' + curr_date.getFullYear())

  $('#month-picker').change ->
    $scope.load()

  $('#month-picker').MonthPicker
    ShowIcon: false

  $scope.add = ->
    register = Register.save($scope.newRegister,
      () ->
        $scope.registers.unshift(register)
        $scope.newRegister = {}
        $scope.load()
      , (response) ->
        $scope.newRegister.errors = response.data.errors
    )

  $scope.delete = (register_id) ->
    if confirm('Впевнений?')
      Register.delete
        id: register_id
      , (success) ->
        $scope.load()
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
  $scope.load()
]
