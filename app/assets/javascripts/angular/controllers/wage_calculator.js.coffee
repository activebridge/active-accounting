@WageCalculatorCtrl = ['$scope', '$http', ($scope, $http) ->
  taxCashing = 0.9925 # (100% - 0.75%)
  $scope.exchange = 0
  $scope.salary = 0
  $scope.vendor = gon.current_counterparty

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

  $http(
    method: 'GET'
    url: '/tax/edit'
  ).then((response) ->
    $scope.socialTax = response.data.social
    $scope.singleTax = response.data.single
    $scope.cashTax = response.data.cash
  )

  $scope.setTaxes = () ->
    $http(
      method: 'PUT'
      url: '/tax'
      data:
        tax:
          social: $scope.socialTax
          single: $scope.singleTax
          cash: $scope.cashTax
    )
]
