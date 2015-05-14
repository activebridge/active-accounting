@ReportHoursCtrl = ['$scope', '$q', '$translate', 'Hours', 'registerDecorator', 'hourDecorator', ($scope, $q , $translate, Hours, registerDecorator, hourDecorator) ->
  registerDecorator($scope)
  hourDecorator($scope)
  $scope.hours = {}
  $scope.filter = {}

  curr_date = new Date()
  $scope.filter = $.datepicker.formatDate('mm/yy', curr_date)

  $scope.changeMonth = () ->
    $scope.hours = Hours.query(month: $scope.filter)
    identifcator = parseInt($scope.filter.slice(0,2))
    $('#MonthPicker_month-picker .active').removeClass( "active" )
    $('.button-' + identifcator).addClass('active')

    $scope.sumByGroup =(array) ->
      total = 0
      $.each array, ->
        total = total + @hours
      return total
  $scope.changeMonth()

  $scope.update = (hour_id, data) ->
    d = $q.defer()
    Hours.update( id: hour_id, {hour: { hours: data.hours } }
      (response) ->
        d.resolve()
        $scope.changeMonth()
      (response) ->
        d.resolve response.data.errors['hours'][0]
    )
    return d.promise
]
