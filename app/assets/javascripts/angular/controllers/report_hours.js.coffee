@ReportHoursCtrl = ['$scope', '$q', '$translate', 'Hours', 'registerDecorator', ($scope, $q , $translate, Hours, registerDecorator) ->
  registerDecorator($scope)
  $scope.hours = {}
  $scope.filter = {}

  curr_date = new Date()
  $scope.filter = $.datepicker.formatDate('mm/yy', curr_date)

  $scope.changeMonth = () ->
    $scope.hours = Hours.query(month: $scope.filter)

    $scope.sumByGroup =(array) ->
      if array.length > 1
        array.reduce (a, b) ->
          a.hours + b.hours
      else
        array[0].hours
  $scope.changeMonth()
]
