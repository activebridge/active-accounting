angular.module('accounting.services').factory 'hourDecorator', ["$q", 'Hours', 'WorkDay', 'Holiday', ($q, Hours, WorkDay, Holiday) ->
  ($scope) ->

    $scope.setNumeric = ->
      $('.number').numeric
        negative: false
        decimal: false
      $('.number').attr('maxlength', '3')
      return
    $scope.setNumeric()

    $scope.addBlankValues = (array) ->
      if array.length < 12

        #add in array current months
        i = 0
        isMonths = []
        while i < array.length
          isMonths.push(array[i].report_month)
          i++

        #add in array empty values
        i = 0
        while i < 12
          if isMonths.indexOf(i+1) == -1
            array.push({ "report_month":i+1, "total_hours":0 })
          i++
        array.sort (a, b) ->
          if a.report_month > b.report_month
            return 1
          if a.report_month < b.report_month
            return -1
          0
      return array

    $scope.LoadCalendar = ->
      Holiday.query (response) ->
        $scope.holidays = response
        holidays = []
        $.each response, () ->
          holidays.push @date

        $scope.dateOptions =
          yearRange: '1900:-0'
          beforeShowDay: (date) ->
            if holidays.indexOf(moment(date).format('DD.MM.YYYY')) != -1
              return [true, 'holidays-to-highlight', '']
            else
              return [true, '']

    $scope.changeMonth = (value, options = {}) ->
      if value != $scope.selectedMonth || options.update
        $scope.selectedMonth = value
        $scope.monthAndYear = value + '/' + ($.trim($scope.year) || $scope.currentYear)
        $scope.hours = Hours.query(month: $scope.monthAndYear, type: options.type)
        $scope.workingDays = WorkDay.get(date: $scope.monthAndYear)
        setDay =
          if $scope.monthAndYear != $scope.currentMonth + '/' + $scope.currentYear
            '1'
          else
            $scope.currentDate
        setDate = setDay + '.' + $scope.monthAndYear.replace('/','.')
        $('#holiday-calendar').datepicker( "setDate", setDate )
        return

]
