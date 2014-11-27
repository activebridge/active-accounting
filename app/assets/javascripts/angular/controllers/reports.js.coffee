@ReportsCtrl = ['$scope', 'Report', 'Register', ($scope, Report, Register) ->

  $scope.load = ->
    $scope.months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
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

    Report.query
      report_type: 'costs'
      , 'months[]': $scope.clickedMonths
      , (response) ->
        $scope.costs = response[0].articles
        $scope.totalCost = response[0].total_values

    Report.query
      report_type: 'translations'
      , 'months[]': $scope.clickedMonths
      , (response) ->
        $scope.translations = response[0].articles
        $scope.totalTranslation = response[0].total_values

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
            dateParse = $.datepicker.parseDate('yy-mm-dd', v.date)
            tr = $('<tr>').append(
                    $('<td>').text($.datepicker.formatDate('dd-mm-yy', dateParse)),
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

]
