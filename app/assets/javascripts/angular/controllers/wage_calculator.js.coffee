@WageCalculatorCtrl = ['$scope', ($scope) ->

  $scope.report = (translation) ->
    if angular.isUndefined($scope.translation)
      translation = 0
    $scope.salaryHrn = $scope.salary*scope.exchange
    $scope.sumSalary = $scope.salaryHrn + translation
    $scope.cashingTax = ($scope.sumSalary/((100-0.75)/100))-$scope.sumSalary
    total = (sumSalary + cashingTax)
    $scope.singleTax = total/0.95 + socialTax
    $scope.total = total.toFixed(2).('.',',')
]
