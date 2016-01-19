@WageCalculatorCtrl = ['$scope', ($scope) ->
  taxCashing = 0.9925 # (100% - 0.75%)
  $scope.exchange = 0
  $scope.salary = 0

  $scope.report = (translation) ->
    if angular.isUndefined($scope.translation)
      translation = 0
    $scope.salaryHrn = $scope.salary * $scope.exchange
    salaryAndTranslation = $scope.salaryHrn + translation
    salaryWithCashTax = salaryAndTranslation / taxCashing
    $scope.cashingTaxSum = salaryWithCashTax - salaryAndTranslation
    $scope.singleTaxSum = salaryWithCashTax/0.95 - salaryWithCashTax
    total = salaryWithCashTax + $scope.socialTax + $scope.singleTaxSum
    $scope.total = total.toFixed(2).replace('.', ',')
]
