@WageCalculatorCtrl = ['$scope', ($scope) ->

  $scope.report = (translation) ->
    if angular.isUndefined($scope.translation)
      translation = 0
    $scope.salaryHrn = $scope.salary*$scope.exchange
    $scope.sumSalary = $scope.salaryHrn + translation + $scope.socialTax
    $scope.cashingTax = $scope.sumSalary*0.0075
    total = ($scope.sumSalary + $scope.cashingTax)/0.95
    $scope.singleTax = total - $scope.sumSalary - $scope.cashingTax
    $scope.total = total.toFixed(2).replace('.', ',')
]
