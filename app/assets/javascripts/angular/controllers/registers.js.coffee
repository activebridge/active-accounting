@RegistersCtrl = ['$scope', '$q', 'PlanRegister', 'Register', 'Article', 'Counterparty', '$translate', '$cookies', ($scope, $q, PlanRegister, Register, Article, Counterparty, $translate, $cookies) ->

  if $scope.sandbox
    $scope.model = PlanRegister
  else
    $scope.model = Register

  $scope.rateDollar = $cookies.rateDollar || 0

  $scope.registers = []

  responseQuery = (response) ->
    lengthResponse = 0
    $(response).each (k, v) ->
      v.value_currency = changeValueCurrency(v.currency, v.value)
      $scope.registers.push(v)
      lengthResponse += 1
    $scope.showLoadRecords = lengthResponse >= 10

  $scope.load = ->
    $scope.model.query
      month: $('#month-picker').val()
      , offset: $scope.registers.length
      , (response) ->
        responseQuery(response)
    $('.select2-container.clear_after_add').select2('val', '')
    return

  $scope.loadRecords = ->
    if $('#month-picker').val()
      $scope.load()
    else
      $scope.filter.fetchRegisters({})

  $scope.newRegister = {}
  $scope.newRegister.errors = {}
  $scope.filter = {}

  changeValueCurrency = (currency, value) ->
    if currency == 'USD'
      valueCurrency = (value * $scope.rateDollar).toFixed(2)
    else
      valueCurrency = value
    return valueCurrency

  $scope.changeValue = ->
    $cookies.rateDollar = $scope.rateDollar
    $.each $scope.registers, (k, v)->
      v.value_currency = changeValueCurrency(v.currency, v.value)

  $scope.filter.show = ->
    $scope.filter.active = !($scope.filter.active)
    $scope.filter.clear()

  $scope.filter.fetchRegisters = (params) ->
    $scope.registers = [] if params.initLoad
    $scope.filter.data.offset = $scope.registers.length
    $scope.model.query($scope.filter.data
      , (response) ->
        responseQuery(response)
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
    $scope.registers = []
    $scope.load()

  $('#month-picker').MonthPicker
    ShowIcon: false,
    i18n: {year: $translate.instant('year'), jumpYears: $translate.instant('jumpYears'), prevYear: $translate.instant('prevYear'), nextYear: $translate.instant('nextYear'), months: $translate.instant('months').split(".") }

  checkMappingRegister = (type, register) ->
    check = 0
    length = 0
    if $scope.filter.dataFilter
      $.each $scope.filter.dataFilter, (k, v)->
        if (register[k]==v) || (k=='article_id' && v==(type+'s').toLowerCase()) || (k=='value' && parseFloat(register[k])>=parseFloat(v))
          check += 1
        length += 1
    return (check == length && $('#month-picker').val() == '') || $('#month-picker').val().replace('/','-') == register.date.slice(3)

  $scope.add = ->
    $scope.newRegister.currency = $scope.currencies[0].value if !$scope.sandbox
    register = $scope.model.save($scope.newRegister,
      () ->
        if checkMappingRegister(register.article.type, $scope.newRegister)
          register.value_currency = changeValueCurrency(register.currency, register.value)
          $scope.registers.unshift(register)
        $('.select2-container.clear_after_add').select2('val', '')
        $scope.newRegister = {date: $scope.newRegister.date, currency: $scope.newRegister.currency}
      , (response) ->
        $scope.newRegister.errors = response.data.errors
      )

  $scope.delete = (register_id, index) ->
    if confirm('Впевнений?')
      Register.delete
        id: register_id
      , (success) ->
        $scope.registers.splice(index,1)
        return

  $scope.update = (register_id, data, index) ->
    d = $q.defer()
    Register.update( id: register_id, {register: data}
      (response) ->
        $.each $scope.articles, (k, v)->
          $scope.registers[index].article = v if v.id == data.article_id
        $.each $scope.counterparties, (k, v)->
          $scope.registers[index].counterparty = v if v.id == data.counterparty_id
        $scope.registers[index].value_currency = changeValueCurrency(data.currency, data.value)
        if !checkMappingRegister($scope.registers[index].article.type, data)
          $scope.registers.splice(index,1)
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
