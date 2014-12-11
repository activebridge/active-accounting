@RegistersCtrl = ['$scope', '$q', 'PlanRegister', 'Register', 'Article', 'Counterparty', '$translate', ($scope, $q, PlanRegister, Register, Article, Counterparty, $translate) ->

  if $scope.sandbox
    $scope.model = PlanRegister
  else
    $scope.model = Register

  $scope.rateDollar = 15.95

  $scope.load = ->
    $scope.registers = $scope.model.query
      month: $('#month-picker').val()
      , () ->
        $scope.changeValue()
    $('.select2-container.clear_after_add').select2('val', '')

  $scope.newRegister = {}
  $scope.newRegister.errors = {}
  $scope.filter = {}

  $scope.changeValue = ->
    $.each $scope.registers, (k, v)->
      if v.currency == 'USD'
        v.value_currency = v.value * $scope.rateDollar
      else
        v.value_currency = v.value

  $scope.filter.show = ->
    $scope.filter.active = !($scope.filter.active)
    $scope.filter.clear()

  $scope.filter.fetchRegisters = ->
    $scope.registers = $scope.model.query($scope.filter.data,
      () ->
        $scope.changeValue()
      )
    $('#month-picker').val('')
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
    {value: "revenues", text: $translate.instant('Revenue')},
    {value: "costs", text: $translate.instant('Cost')},
    {value: "translations", text: $translate.instant('Translation')}
  ]

  $scope.currencies = [
    {value: "UAH", text: $translate.instant('currency_UA')},
    {value: "USD", text: 'USD'}
  ]

  $scope.newRegister.currency = $scope.currencies[0].value

  $scope.counterparties = Counterparty.query
    scope: 'active'
    () ->
      $('select.counterparty').select2({width: '200px'})
      $('select.currency').select2({width: '65px', minimumResultsForSearch: '5' })
  
  $.datepicker.setDefaults( $.datepicker.regional[ $translate.instant('datePickerLocal') ] )
  $('#date').datepicker
    dateFormat: 'dd-mm-yy',
    onSelect: (date, obj) ->
      $scope.newRegister.date = date

  $('#dateFilter').datepicker(dateFormat: 'dd-mm-yy')

  $scope.openDatepicker = ->
    $('input.dateup').datepicker({ dateFormat: "dd-mm-yy" }).focus()
    return

  $scope.showSelect = ->
    $('.search-select').select2({width: '100%'})
    $('select.currency').select2({width: '65px', minimumResultsForSearch: '5' })
    $scope.valueOnlyNumeric()
    return
  
  curr_date = new Date()

  $scope.newRegister.date = $.datepicker.formatDate('dd-mm-yy', curr_date)

  month_picker_date = $.datepicker.formatDate('mm/yy', curr_date)
  $('#month-picker').val(month_picker_date)

  $('#month-picker').change ->
    $scope.load()

  $('#month-picker').MonthPicker
    ShowIcon: false,
    i18n: {year: $translate.instant('year'), jumpYears: $translate.instant('jumpYears'), prevYear: $translate.instant('prevYear'), nextYear: $translate.instant('nextYear'), months: $translate.instant('months').split(".") }

  $scope.add = ->
    $scope.newRegister.currency = $scope.currencies[0].value if !$scope.sandbox
    register = $scope.model.save($scope.newRegister,
      () ->
        $scope.registers.unshift(register)
        $scope.newRegister = {date: $scope.newRegister.date, currency: $scope.newRegister.currency}
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
