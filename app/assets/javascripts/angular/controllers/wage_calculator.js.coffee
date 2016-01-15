@WageCalculatorCtrl = ['$scope', ($scope) ->
  $scope.cashingIndex = 0.9925 # (100-0.75)/100

  $scope.report = (translation) ->
    if angular.isUndefined($scope.translation)
      $scope.translation = 0
    $scope.salaryHrn = $scope.salary*$scope.exchange + $scope.translation
    $scope.sumSalary = $scope.salaryHrn
    $scope.cashingTax = $scope.sumSalary/$scope.cashingIndex - $scope.sumSalary
    total = ($scope.sumSalary + $scope.cashingTax)/0.95 + $scope.socialTax
    $scope.singleTax = total - $scope.sumSalary - $scope.socialTax - $scope.cashingTax
    $scope.total = total.toFixed(2).replace('.', ',')
]
