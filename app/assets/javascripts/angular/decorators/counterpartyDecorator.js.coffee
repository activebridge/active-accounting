angular.module('accounting.services').factory 'counterpartyDecorator', ["$q", 'Counterparty', '$translate', ($q, Counterparty, $translate) ->
  ($scope) ->
    $scope.special_types = ['VENDOR', 'Vendor', 'HR']

    $scope.isVendor = (type) ->
      $scope.special_types.indexOf(type) > -1

    $scope.currencies = [
      {value: "UAH", text: $translate.instant('currency_UA')},
      {value: "USD", text: 'USD'}
    ]

    $scope.displayTypes = gon.counterparty_display_types

    $scope.typesOptions = $.map($scope.displayTypes, (type) ->
      {
        value: type.toUpperCase()
        text: $translate.instant(type)
      }
    )
]
