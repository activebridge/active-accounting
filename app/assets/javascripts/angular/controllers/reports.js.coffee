@ReportsCtrl = ['$rootScope', '$scope', '$compile', 'Report', 'Register', 'PlanRegister', '$translate', '$cookies', 'Article', 'Counterparty', 'registerDecorator',
 ($rootScope, $scope, $compile, Report, Register, PlanRegister, $translate, $cookies, Article, Counterparty, registerDecorator) ->
  $rootScope.reportsController = $scope
  registerDecorator($scope)

  $scope.rateDollar = $cookies.rateDollar || 0

  $scope.load = (value) ->
    $scope.data = {}
    $scope.data.revenues = {}
    $scope.data.costs = {}
    $scope.data.translations = {}
    $scope.data.loans = {}
    $scope.months = $translate.instant('month_all').split(',')
    curr_date = new Date()
    $scope.funcPlan.show[curr_date.getMonth()] = false
    $scope.CheckedYear = value
    $scope.clickedMonths = [(curr_date.getMonth()+1) + '/' + $scope.CheckedYear]
    $scope.currentMonth = $scope.months[curr_date.getMonth()]
    $scope.loadDates($scope.clickedMonths, true)

  mergeObjects = (result, object) ->
    angular.forEach object, (value, key) ->
      result = $.extend(true, [], result, value)
    result

  unmergeObjects = (month, object) ->
    angular.forEach object, (value, key) ->
      delete value[month]
      $scope[key] = {}
      $scope[key] = mergeObjects($scope[key], value)

  $scope.loadDates = (month, clicked) ->
    $cookies.rateDollar = String($scope.rateDollar).replace(',','.')
    m = parseInt(String(month).split('/')[0])

    if clicked
      Report.query
        report_type: 'revenues'
        , 'months[]': month
        , rate_currency: $scope.rateDollar
        , (response) ->
          $scope.data.revenues[m] = response[0].articles
          $scope.revenues = mergeObjects($scope.revenues, $scope.data.revenues)
          $scope.totalRevenue = $.extend(true, [], $scope.totalRevenue, response[0].total_values)
          $scope.totalRevenuePlan = $.extend(true, [], $scope.totalRevenuePlan, response[0].total_values_plan)

      Report.query
        report_type: 'costs'
        , 'months[]': month
        , rate_currency: $scope.rateDollar
        , (response) ->
          $scope.data.costs[m] = response[0].articles
          $scope.costs = mergeObjects($scope.costs, $scope.data.costs)
          $scope.totalCost = $.extend(true, [], $scope.totalCost, response[0].total_values)
          $scope.totalCostPlan = $.extend(true, [], $scope.totalCostPlan, response[0].total_values_plan)

      Report.query
        report_type: 'translations'
        , 'months[]': month
        , rate_currency: $scope.rateDollar
        , (response) ->
          $scope.data.translations[m] = response[0].articles
          $scope.translations = mergeObjects($scope.translations, $scope.data.translations)
          $scope.totalTranslation = $.extend(true, [], $scope.totalTranslation, response[0].total_values)
          $scope.totalTranslationPlan = $.extend(true, [], $scope.totalTranslationPlan, response[0].total_values_plan)

      Report.query
        report_type: 'loans'
        , 'months[]': month
        , rate_currency: $scope.rateDollar
        , (response) ->
          $scope.data.loans[m] = response[0].articles
          $scope.loans = mergeObjects($scope.loans, $scope.data.loans)
          $scope.totalLoan = $.extend(true, [], $scope.totalLoan, response[0].total_values)
          $scope.totalLoanPlan = $.extend(true, [], $scope.totalLoanPlan, response[0].total_values_plan)
    else
      unmergeObjects(m, $scope.data)

  $scope.monthsChange = (month, clicked) ->
    m = $scope.months.indexOf(month)+1
    y = $scope.CheckedYear
    date = m + '/' + y
    if clicked
      $scope.funcPlan.show[m-1] = false
      $scope.clickedMonths.push date
    else
      trashMonth = $scope.clickedMonths.indexOf(date)
      $scope.clickedMonths.splice(trashMonth, 1)
      delete $scope.funcPlan.show[m-1]
    $scope.loadDates(date, clicked)

  $scope.range = (start, end) ->
    return [start..end]

  $scope.isShow = (month) ->
    y = $scope.CheckedYear
    date = month + '/' + y
    return $scope.clickedMonths.indexOf(date) >= 0

  $scope.parseMonthName = (month) ->
    return $scope.months.indexOf(month)+1

  $scope.buttonShow = ->
    return $scope.rateDollar != $cookies.rateDollar

  $scope.funcPlan = {}
  $scope.funcPlan.show = {}

  $scope.funcPlan.showAll = (value) ->
    $.each $scope.clickedMonths, (k, v)->
      $scope.funcPlan.show[parseInt(v.slice(0, -5))-1] = value

  $scope.funcPlan.showComand = (value) ->
    show = []
    $.each $scope.funcPlan.show, (k, v)->
      show.unshift(v) if v && value == "show"
      show.unshift(v) if !v && value == "hide"
    return show.length < $scope.clickedMonths.length

  $scope.funcPlan.showRecord = (record) ->
    valueNotNull = false
    valuePlanNotNull = false
    $.each record.values, (k, v)->
      valueNotNull = true if parseFloat(v) != 0
    $.each record.valuesPlan, (k, v)->
      valuePlanNotNull = true if parseFloat(v) != 0 && $scope.funcPlan.show[parseInt(k)-1]
    return valueNotNull || valuePlanNotNull

  $scope.funcPlan.showCarrot = (counterparties) ->
    show = []
    $.each counterparties, (k, v)->
      show.unshift($scope.funcPlan.showRecord(v)) if $scope.funcPlan.showRecord(v)
    return show.length > 0

  $scope.articles = Article.query ->

  $scope.counterparties = Counterparty.query
    scope: 'active'
    () ->

  $scope.getRegisters = (month, event, type, article_id, sandbox) ->
    showRegistersTable = (month, article_id, type, reportItem, sandbox)->
      date = month + '/' + $scope.CheckedYear
      if sandbox
        model = PlanRegister
      else
        model = Register
      model.query
        month: date,
        type: type,
        article_id: article_id
        (response)->
          if article_id == null
            name = type + sandbox
          else
            name = 'article' +  article_id + sandbox

          $scope.responseQuery(response, name)

          reportItem.after("<edit-register ng-model=" + name + " sandbox=" + sandbox + " articles='articles' counterparties='counterparties'><edit-register>")
          $compile($(reportItem).next())($scope);

    reportItem = $(event.target).parents('.report-item')
    nextEl = reportItem.next()
    alreadyDisplayedTable = nextEl.hasClass('registers-table')
    if alreadyDisplayedTable
      table = nextEl
      justHideTable = (table.data('month') == month) && (table.data('article_id') == article_id)
      if justHideTable
        table.remove()
        showRegistersTable(month, article_id, type, reportItem, sandbox)
      else
        table.remove()
    else
      showRegistersTable(month, article_id, type, reportItem, sandbox)

  $scope.currYear = new Date().getFullYear()

  loadYears = ->
    Report.years (response) ->
      $scope.years = response['years']

  loadYears()

  $scope.load($scope.currYear)

  $scope.CheckYears = (value) ->
    curr_date = new Date()
    $.each $(".multiple-picker label"), (index, value) ->
      if (curr_date.getMonth()) == index
        $(value).scope().clicked = true
        return
      $(value).scope().clicked = undefined
      return
    $scope.funcPlan.show = {}
    $scope.funcPlan.show[curr_date.getMonth()] = false

    $scope.load(value)

  $("input.value").numeric({ decimalPlaces: 2 })

  $scope.setSelect2 = ->
    $('select.year-select').select2({ 'minimumResultsForSearch': 5 })
    return
]
