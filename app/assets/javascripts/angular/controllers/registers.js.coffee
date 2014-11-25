@RegistersCtrl = ['$scope', '$q', 'Register', 'Article', 'Counterparty', ($scope, $q, Register, Article, Counterparty) ->
  $scope.load = ->
    $scope.registers = Register.query(month: $('#month-picker').val())
    $('.select2-container').select2('val', '')
    showColorpicker()

  $scope.newRegister = {}
  $scope.newRegister.errors = {}
  $scope.filter= {}

  $scope.filter.show = ->
    $scope.filter.active = !($scope.filter.active)
    $scope.filter.clear()

  $scope.filter.fetchRegisters = ->
    $scope.registers = Register.query($scope.filter.data)
    $('#month-picker').val('')
    showColorpicker()
    return

  $scope.valueOnlyNumeric = ->
    $("input.value").numeric({ decimalPlaces: 2 })

  $scope.filter.clear = ->
    $('select.search').select2('val', '')
    $('input.search').val('')
    $('#dateFilter').val('')
    $scope.filter.data = {}
    return

  $scope.articles = Article.query ->
    $('select.article').select2({width: '200px'})

  $scope.articleTypes = [
    {value: "revenues", text: "(НАДХОДЖЕННЯ)"},
    {value: "costs", text: "(ВИТРАТИ)"},
    {value: "translations", text: "(ТРАНСЛЯЦІЯ)"}
  ]

  $scope.counterparties = Counterparty.query
    scope: 'active'
    () ->
      $('select.counterparty').select2({width: '200px'})

  $('#date').datepicker
    dateFormat: 'dd-mm-yy',
    onSelect: (date, obj) ->
      $scope.newRegister.date = date

  $('#dateFilter').datepicker(dateFormat: 'yy-mm-dd')

  $scope.openDatepicker = ->
    $('input.dateup').datepicker({ dateFormat: "dd-mm-yy" }).focus()
    return

  $scope.showSelect = ->
    $('.search-select').select2({width: '100%'})
    $scope.valueOnlyNumeric()
    return
  
  curr_date = new Date()

  $scope.newRegister.date = $.datepicker.formatDate('dd-mm-yy', curr_date)

  month_picker_date = $.datepicker.formatDate('mm/yy', curr_date)
  $('#month-picker').val(month_picker_date)

  $('#month-picker').change ->
    $scope.load()

  $('#month-picker').MonthPicker
    ShowIcon: false

   $scope.colectionColors = [
    {value: "#d06b64", text: "#d06b64"},
    {value: "#ff7537", text: "#ff7537"},
    {value: "#ffad46", text: "#ffad46"},
    {value: "#42d692", text: "#42d692"},
    {value: "#16a765", text: "#16a765"},
    {value: "#7bd148", text: "#7bd148"},
    {value: "#b3dc6c", text: "#b3dc6c"},
    {value: "#fbe983", text: "#fbe983"},
    {value: "#fad165", text: "#fad165"},
    {value: "#92e1c0", text: "#92e1c0"},
    {value: "#9fe1e7", text: "#9fe1e7"},
    {value: "#9fc6e7", text: "#9fc6e7"},
    {value: "#4986e7", text: "#4986e7"},
    {value: "#9a9cff", text: "#9a9cff"},
    {value: "#b99aff", text: "#b99aff"},
    {value: "#cca6ac", text: "#cca6ac"},
    {value: "#f691b2", text: "#f691b2"},
    {value: "#cd74e6", text: "#cd74e6"},
    {value: "#a47ae2", text: "#a47ae2"}
  ]

  showColorpicker = ->
    setTimeout (->
      $('select.color-record').simplecolorpicker({picker: true, theme: 'glyphicons', pickerDelay: 1000})
      return
    ), 500

  $scope.add = ->
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
        if data.background is undefined
          if $('#month-picker').val()
            $scope.load()
          else
            $scope.filter.fetchRegisters()
        d.resolve()
      (response) ->
        d.resolve('')
        $scope.response_id = response.data.id
        $scope.errors = response.data.error   
    )
    return d.promise
  $scope.load()
  $scope.valueOnlyNumeric()

  $scope.clearError = () ->
    $scope.errors = []
]
