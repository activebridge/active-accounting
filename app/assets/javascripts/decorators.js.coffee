angular.module('accounting.services').factory 'registerDecorator', ["$rootScope", "$q", "$translate", "$cookies", "Register", "PlanRegister", ($rootScope, $q, $translate, $cookies, Register, PlanRegister) ->
  ($scope) ->
    if $scope.sandbox
      $scope.model = PlanRegister
      $scope.model.key = 'plan_register'
    else
      $scope.model = Register
      $scope.model.key = 'register'

    $scope.rateDollar = $cookies.rateDollar || 0

    $scope.changeValueCurrency = (currency, value) ->
      if currency == 'USD'
        valueCurrency = parseFloat((value * $scope.rateDollar).toFixed(2))
      else
        valueCurrency = value
      return valueCurrency

    #remove register if it does not meet the filter for update
    $scope.checkMappingRegister = (type, register) ->
      dateFilter = $('#month-picker').val().replace('/','-')

      if Object.keys($scope.filter.dataFilter).length > 2
        if !!$scope.filter.data.counterparty_id && parseInt($scope.filter.data.counterparty_id) != register.counterparty_id
          return false
        else if !!$scope.filter.data.value && parseInt($scope.filter.data.value) > parseInt(register.value)
          return false
        else if !!$scope.filter.data.article_id && parseInt($scope.filter.data.article_id) != register.article_id
          return false
      return dateFilter == register.date.slice(3)

    $scope.currencies =
      [
        {value: "UAH", text: $translate.instant('currency_UA')},
        {value: "USD", text: 'USD'}
      ]

    $scope.openDatepicker = ->
      unless $('input.dateup').hasClass('hasDatepicker')
        $('input.dateup').datepicker({ dateFormat: "dd-mm-yy" }).focus()
        return

    $scope.showSelect = ->
      unless $('input.dateup').hasClass('hasDatepicker')
        $('.search-select').select2({width: '100%'})
        $('select.currency').select2({width: '65px', minimumResultsForSearch: '5' })
        $("input.value").numeric({ decimalPlaces: 2 })
        return

    $scope.responseQuery = (response, name) ->
      $scope[name] = []
      lengthResponse = 0
      $(response).each (k, v) ->
        v.value_currency = $scope.changeValueCurrency(v.currency, v.value)
        v.date_reverse = v.date.split("-").reverse().join("-")
        $scope[name].push(v)
        lengthResponse += 1
      $scope.showLoadRecords = lengthResponse >= 10

    $scope.update = (register_id, data, index, type) ->
      if $scope.ngModel != undefined
        $scope.registers = $scope.ngModel
      d = $q.defer()
      params = {}
      articleId = $scope.registers[index].article.id
      params[$scope.model.key] = data
      $scope.model.update( id: register_id, params
        (response) ->
          return if data.background
          $.each $scope.articles, (k, v)->
            $scope.registers[index].article = v if v.id == data.article_id
          $.each $scope.counterparties, (k, v)->
            $scope.registers[index].counterparty = v if v.id == data.counterparty_id
          $scope.registers[index].value_currency = $scope.changeValueCurrency(data.currency, data.value)
          if $scope.ngModel == undefined
            if !$scope.checkMappingRegister($scope.registers[index].article.type, data)
              $scope.registers.splice(index,1)
          else
            # remove report table if article change
            $('.registers-table').remove() if $('.registers-table').length > 1
            #remove register in group article if article change
            $scope.registers.splice(index,1) if articleId != data.article_id
          d.resolve()
        (response) ->
          d.resolve('')
          $scope.response_id = response.data.id
          $scope.errors = response.data.error
      )
      if type
        $rootScope.reportsController.loadDates()
      return d.promise

    $scope.setMonthPicker = ->
      $('#month-picker').MonthPicker
        ShowIcon: false,
        i18n: {year: $translate.instant('year'), jumpYears: $translate.instant('jumpYears'), prevYear: $translate.instant('prevYear'), nextYear: $translate.instant('nextYear'), months: $translate.instant('months').split(".") }

    $scope.setMonthPicker()
]
