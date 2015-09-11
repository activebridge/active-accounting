@RegistersCtrl = ['$scope', '$q', 'PlanRegister', 'Register', 'Article', 'Counterparty', '$translate', '$cookies', 'registerDecorator',
 ($scope, $q, PlanRegister, Register, Article, Counterparty, $translate, $cookies, registerDecorator) ->
  registerDecorator($scope)

  $scope.registers = []

  responseQuery = (response) ->
    lengthResponse = 0
    $(response).each (k, v) ->
      v.value_currency = $scope.changeValueCurrency(v.currency, v.value)
      v.date_reverse = v.date.split("-").reverse().join("-")
      $scope.registers.push(v)
      lengthResponse += 1
    $scope.showLoadRecords = lengthResponse >= 10

  $scope.newRegister = {}
  $scope.newRegister.errors = {}
  $scope.filter = {}
  $scope.filter.data = {}

  $scope.changeValue = ->
    $cookies.rateDollar = $scope.rateDollar.replace(',','.')
    $.each $scope.registers, (k, v)->
      v.value_currency = $scope.changeValueCurrency(v.currency, v.value)

  $scope.filter.show = ->
    $scope.filter.active = !($scope.filter.active)
    $scope.filter.clear()

  $scope.filter.fetchRegisters = (params) ->
    $scope.registers = [] if params.initLoad
    $scope.counterpartiesWithoutPay = []
    $scope.filter.data.offset = $scope.registers.length
    $scope.filter.dataFilter = $scope.filter.data
    $scope.model.query($scope.filter.data
      , (response) ->
        responseQuery(response)
      )
    if $scope.filter.data.month
      $scope.counterpartiesWithoutPay = Counterparty.payments
        month: $scope.filter.data.month
        , sandbox: $scope.sandbox
    return

  $scope.valueOnlyNumeric = ->
    $("input.value").numeric({ decimalPlaces: 2 })

  $scope.filter.clear = ->
    $('select.search').select2('val', '')
    $('input.search').val('')
    $('#dateFilter').val('')
    $scope.filter.data = { month: $scope.filter.data.month }
    return

  $scope.articles = Article.query ->
    $('select.article').select2({width: '200px'})

  $scope.articleTypes = [
    {value: "revenues", text: $translate.instant('Revenue')},
    {value: "costs", text: $translate.instant('Cost')},
    {value: "translations", text: $translate.instant('Translation')}
  ]


  $scope.CounterpartyTypes = [
    { value: "Customer", text: 'Customers' },
    { value: "Vendor", text: 'Vendors' },
    { value: "Other", text: 'Others' }
  ]

  $scope.CounterpatiesWithoutPayment = 'Customer'

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

  curr_date = new Date()

  $scope.newRegister.date = $.datepicker.formatDate('dd-mm-yy', curr_date)

  month_picker_date = $.datepicker.formatDate('mm/yy', curr_date)

  $scope.filter.data.month = month_picker_date

  $scope.filter.changeMonth = ->
    if $scope.filter.active
      $scope.filter.data.date = undefined
      return
    $scope.registers = []
    $scope.filter.fetchRegisters(false)
  $scope.filter.changeMonth()

  $scope.add = ->
    $scope.newRegister.currency = $scope.currencies[0].value if !$scope.sandbox
    register = $scope.model.save($scope.newRegister,
      () ->
        if $scope.checkMappingRegister(register.article.type, $scope.newRegister)
          register.value_currency = $scope.changeValueCurrency(register.currency, register.value)
          $scope.registers.unshift(register)
        $('.select2-container.clear_after_add').select2('val', '')
        $.each $scope.counterpartiesWithoutPay, (k, v)->
          if v.id == parseInt($scope.newRegister.counterparty_id)
            $scope.counterpartiesWithoutPay.splice(k,1)
            return
        $scope.newRegister = {date: $scope.newRegister.date, currency: $scope.newRegister.currency}
      , (response) ->
        $scope.newRegister.errors = response.data.errors
      )

  $scope.delete = (register_id, index) ->
    if confirm('Впевнений?')
      $scope.model.delete
        id: register_id
      , (success) ->
        $('tr#register_' + register_id).remove()
        return

  $scope.valueOnlyNumeric()

  $scope.clearError = () ->
    $scope.errors = []
]
