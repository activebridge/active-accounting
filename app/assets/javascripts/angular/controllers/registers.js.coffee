@RegistersCtrl = ['$scope', '$q', 'Register', 'Article', 'Counterparty', ($scope, $q, Register, Article, Counterparty) ->
  $scope.load = ->
    $scope.registers = Register.query(month: $('#month-picker').val())
    $('.select2-container').select2('val', '')

  $scope.newRegister = {}
  $scope.newRegister.errors = {}

  $scope.articles = Article.query ->
    $('select.article').select2({width: '200px'})

  $scope.counterparties = Counterparty.query
    scope: 'active'
    () ->
      $('select#counterparty').select2({width: '200px'})

  $('#date').datepicker
    dateFormat: 'dd-mm-yy',
    onSelect: (date, obj) ->
      $scope.newRegister.date = date

  $scope.openDatepicker = ->
    $('input.dateup').datepicker({ dateFormat: "dd-mm-yy" }).focus()
    return

  $scope.showSelect = ->
    $('.search-select').select2({width: '100%'})
    return
  
  curr_date = new Date()

  $scope.newRegister.date = $.datepicker.formatDate('dd-mm-yy', curr_date)

  month_picker_date = $.datepicker.formatDate('mm/yy', curr_date)
  $('#month-picker').val(month_picker_date)

  $('#month-picker').change ->
    $scope.load()

  $('#month-picker').MonthPicker
    ShowIcon: false

  $scope.add = ->
    $scope.newRegister.value = $scope.newRegister.value.replace(",",".")
    register = Register.save($scope.newRegister,
      () ->
        $scope.registers.unshift(register)
        $scope.newRegister = {date: $scope.newRegister.date}
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
  
   $scope.update = (register_id, data) ->
    d = $q.defer()
    Register.update( id: register_id, {register: data}
      (response) ->
        $scope.registers = Register.query()
        d.resolve()
      (response) ->
        d.resolve('')
        $scope.response_id = response.data.id
        $scope.errors = response.data.error   
    )
    return d.promise
  $scope.load()

  $scope.clearError = () ->
    $scope.errors = []
]
