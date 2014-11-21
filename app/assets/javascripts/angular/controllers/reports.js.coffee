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

  $scope.getRegisters = (month, event, clicked, type, article_id) ->
    tableDiv = $(event.target.parentElement).next()
    if clicked
      date = month + '/' + (new Date().getFullYear())
      if tableDiv[0].innerHTML
        tableDiv[0].innerHTML = ''
      registers = Register.query
        month: date,
        type: type,
        article_id: article_id,
        () ->
          html = $('.register_table').clone()
          html.removeClass('ng-hide')
          $.each registers, (k, v)->
            tr =  $('<tr>').append(
                    $('<td>').text(v.date),
                    $('<td>').text(v.article.name),
                    $('<td>').text(v.counterparty.name),
                    $('<td>').text(v.value),
                    $('<td>').text(v.notes || ''))
            table = html.append(tr);
            tableDiv.append(table)
          tableDiv.append(html) unless registers.length
    else
      tableDiv[0].innerHTML = ''

  $scope.load()

]
