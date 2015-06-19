angular.module('accounting.services').factory 'hourDecorator', ["$q", 'Hours', 'WorkDay', 'Holiday', ($q, Hours, WorkDay, Holiday) ->
  ($scope) ->
    $scope.updateHours = (hour_id, data, successFunction) ->
      d = $q.defer()
      Hours.update( id: hour_id, {hour: { hours: data.hours } }
        (response) ->
          d.resolve()
          successFunction
        (response) ->
          d.resolve response.data.errors['hours'][0]
      )
      return d.promise

    $scope.delete = (hours_id, index, successFunction) ->
      if confirm('Впевнений?')
        Hours.delete
          id: hours_id
        , (success) ->
          $scope.hours.splice(index,1)
          successFunction
          return

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
          isMonths.push(array[i].month)
          i++

        #add in array empty values
        i = 0
        while i < 12
          if isMonths.indexOf(i+1) == -1
            array.push({ "month":i+1, "total_hours":0 })
          i++
        array.sort (a, b) ->
          if a.month > b.month
            return 1
          if a.month < b.month
            return -1
          0
      return array

    $scope.changeMonth = (value, options = {}) ->
      if value != $scope.selectedMonth || options.changeYear
        $scope.selectedMonth = value
        $scope.monthAndYear = value + '/' + ($.trim($scope.year) || $scope.currentYear)
        $scope.hours = Hours.query(month: $scope.monthAndYear, type: options.type)
        $scope.workingDays = WorkDay.get(date: $scope.monthAndYear)
        Holiday.by_month
          month: $scope.monthAndYear
          (response) ->
            $scope.holidays = response
            holidays = []
            $.each response.holidays, () ->
              holidays.push @date

            $scope.dateOptions =
              yearRange: '1900:-0'
              beforeShowDay: (date) ->
                if holidays.indexOf(moment(date).format('DD.MM.YYYY')) != -1
                  return [true, 'holidays-to-highlight', '']
                else
                  return [true, '']

            setDay =
              if $scope.monthAndYear != $scope.currentMonth + '/' + $scope.currentYear
                '1'
              else
                $scope.currentDate
            setDate = setDay + '.' + $scope.monthAndYear.replace('/','.')
            $('#holiday-calendar').datepicker( "setDate", setDate )
]
