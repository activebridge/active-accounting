@ReportsCtrl = ['$scope', 'Report', 'Register', '$translate', ($scope, Report, Register, $translate) ->

  $scope.load = ->
    $scope.months = $translate.instant('month_all').split(',')
    curr_date = new Date()
    $scope.clickedMonths = [(curr_date.getMonth()+1) + '/' + curr_date.getFullYear()]
    $scope.currentMonth = $scope.months[curr_date.getMonth()]
    $scope.loadDates()

  $scope.loadDates = ->
    Report.query
      report_type: 'revenues'
      , 'months[]': $scope.clickedMonths
      , (response) ->
        $scope.revenues = response[0].articles
        $scope.totalRevenue = response[0].total_values
        $scope.totalRevenuePlan = response[0].total_values_plan

    Report.query
      report_type: 'costs'
      , 'months[]': $scope.clickedMonths
      , (response) ->
        $scope.costs = response[0].articles
        $scope.totalCost = response[0].total_values
        $scope.totalCostPlan = response[0].total_values_plan

    Report.query
      report_type: 'translations'
      , 'months[]': $scope.clickedMonths
      , (response) ->
        $scope.translations = response[0].articles
        $scope.totalTranslation = response[0].total_values
        $scope.totalTranslationPlan = response[0].total_values_plan

  $scope.monthsChange = (month, clicked) ->
    m = $scope.months.indexOf(month)+1
    y = new Date().getFullYear()
    date = m + '/' + y
    if clicked
      $scope.clickedMonths.push date
    else
      trashMonth = $scope.clickedMonths.indexOf(date)
      $scope.clickedMonths.splice(trashMonth, 1)
    $scope.loadDates()

  $scope.range = (start, end) ->
    return [start..end]

  $scope.isShow = (month) ->
    y = new Date().getFullYear()
    date = month + '/' + y
    return $scope.clickedMonths.indexOf(date) >= 0

  $scope.parseMonthName = (month) ->
    return $scope.months.indexOf(month)+1

  $scope.funcPlan = {}
  $scope.funcPlan.show = {}

  $scope.funcPlan.showAll = (param) ->
    $.each $scope.clickedMonths, (k, v)->
      $scope.funcPlan.show[parseInt(v.slice(0, -5))-1] = param

  $scope.funcPlan.checkValues = (values) ->
    show = false
    $.each values, (k, v)->
      show = true if parseFloat(v) != 0
    return show

  $scope.funcPlan.checkShow = (values) ->
    show = false
    $.each $scope.funcPlan.show, (k, v)->
      show = true if v && parseFloat(values[parseInt(k)+1]) != 0
    return show

  $scope.getRegisters = (month, event, type, article_id) ->
    showRegistersTable = (month, article_id, type, reportItem)->
      date = month + '/' + (new Date().getFullYear())
      registers = Register.query
        month: date,
        type: type,
        article_id: article_id,
        () ->
          template = $('#registers-table-template').children('table').clone()
          template.data('month', month)
          template.data('article_id', article_id)
          $.each registers, (k, v)->
            tr = $('<tr>').append(
                    $('<td>').text(v.date),
                    $('<td>').text(v.article.name),
                    $('<td>').text(if v.counterparty then v.counterparty.name else ''),
                    $('<td>').text(v.value),
                    $('<td>').text(v.notes || ''))
            template.append(tr)
          reportItem.after(template)

    reportItem = $(event.target).parents('.report-item')
    nextEl = reportItem.next()
    alreadyDisplayedTable = nextEl.hasClass('registers-table')
    if alreadyDisplayedTable
      table = nextEl
      justHideTable = (table.data('month') == month) && (table.data('article_id') == article_id)
      if justHideTable
        table.remove()
      else
        table.remove()
        showRegistersTable(month, article_id, type, reportItem)
    else
      showRegistersTable(month, article_id, type, reportItem)

  $scope.load()

  $scope.changeLanguage = (key) ->
    $translate.use(key)
]
