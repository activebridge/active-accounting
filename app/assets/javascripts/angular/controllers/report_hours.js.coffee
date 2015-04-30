@ReportHoursCtrl = ['$scope', '$q', '$translate', 'Hours', 'registerDecorator', ($scope, $q , $translate, Hours, registerDecorator) ->
  registerDecorator($scope)
  $scope.hours = {}
  $scope.filter = {}

  curr_date = new Date()
  $scope.filter = $.datepicker.formatDate('mm/yy', curr_date)

  $scope.changeMonth = () ->
    $scope.hours = Hours.query(month: $scope.filter)

    $scope.sumByGroup =(array) ->
      total = 0
      $.each array, ->
        total = total + @hours
      return total
  $scope.changeMonth()
]
