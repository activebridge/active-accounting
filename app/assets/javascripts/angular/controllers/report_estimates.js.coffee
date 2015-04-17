@ReportEstimatesCtrl = ['$scope', '$q', '$translate', 'Estimate', 'registerDecorator', ($scope, $q , $translate, Estimate, registerDecorator) ->
  registerDecorator($scope)
  $scope.estimates = {}
  $scope.filter = {}

  curr_date = new Date()
  $scope.filter = $.datepicker.formatDate('mm/yy', curr_date)

  $scope.changeMonth = () ->
    $scope.estimates = Estimate.query(month: $scope.filter)

    $scope.sumByGroup =(array) ->
      if array.length > 1
        array.reduce (a, b) ->
          a.hours + b.hours
      else
        array[0].hours
  $scope.changeMonth()
]
