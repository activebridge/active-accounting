@WageCalculatorCtrl = ['$scope', '$http', 'Flash', '$translate', ($scope, $http, Flash, $translate) ->
  $scope.flashDuretion = 5000
  $scope.exchange = 0
  $scope.salary = 0
  $scope.admin = gon.admin

  $scope.report = (translation) ->
    if angular.isUndefined($scope.translation)
      translation = 0
    $scope.salaryHrn = $scope.salary * $scope.exchange
    salaryAndTranslation = $scope.salaryHrn + translation
    salaryWithCashTax = salaryAndTranslation / percentToIndex($scope.cashTax)
    $scope.cashingTaxSum = salaryWithCashTax - salaryAndTranslation
    $scope.singleTaxSum = salaryWithCashTax/percentToIndex($scope.singleTax) - salaryWithCashTax
    total = salaryWithCashTax + $scope.socialTax + $scope.singleTaxSum
    $scope.total = total.toFixed(2).replace('.', ',')

  # gets all taxes
  $http(
    method: 'GET'
    url: '/tax/edit'
  ).then((response) ->
    $scope.socialTax = response.data.social
    $scope.singleTax = response.data.single
    $scope.cashTax = response.data.cash
  )

  # sets all taxes
  $scope.setTaxes = () ->
    $http(
      method: 'PUT'
      url: '/tax'
      data:
        tax:
          social: $scope.socialTax
          single: $scope.singleTax
          cash: $scope.cashTax
    ).success(
      Flash.create('success', $translate.instant('tax_updated'))
    ).error((response) ->
      Flash.create('danger', $translate.instant('tax_update_error'))
    )

  percentToIndex = (tax) ->
    1 - tax/100
]
