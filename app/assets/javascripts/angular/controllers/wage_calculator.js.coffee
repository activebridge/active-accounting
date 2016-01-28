@WageCalculatorCtrl = ['$scope', '$http', 'Flash', '$translate', 'Tax', ($scope, $http, Flash, $translate, Tax) ->
  $scope.flashDuretion = 5000
  $scope.exchange = 0
  $scope.salary = 0
  $scope.admin = gon.admin

  $scope.report = (translation) ->
    if angular.isUndefined($scope.translation)
      translation = 0
    $scope.salaryHrn = $scope.salary * $scope.exchange
    salaryAndTranslation = $scope.salaryHrn + translation
    salaryWithCashTax = salaryAndTranslation / percentToIndex($scope.tax.cash)
    $scope.cashingTaxSum = salaryWithCashTax - salaryAndTranslation
    $scope.singleTaxSum = salaryWithCashTax/percentToIndex($scope.tax.single) - salaryWithCashTax
    total = salaryWithCashTax + $scope.tax.social + $scope.singleTaxSum
    $scope.total = total.toFixed(2).replace('.', ',')

  # gets all taxes
  Tax.edit((response) ->
    $scope.tax = response
    # $scope.socialTax = response.social
    # $scope.singleTax = response.single
    # $scope.cashTax = response.cash
  )

  # sets all taxes
  $scope.setTaxes = () ->
    Tax.update
      tax: $scope.tax
        # social: $scope.socialTax
        # single: $scope.singleTax
        # cash: $scope.cashTax
      , (response) ->
        Flash.create('success', $translate.instant('tax_updated'))
      , (response) ->
        Flash.create('danger', $translate.instant('tax_update_error'))

  percentToIndex = (tax) ->
    1 - tax/100
]
