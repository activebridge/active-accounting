@VendorHolidaysCtrl = ['$scope', 'Holiday', ($scope, Holiday) ->
  $scope.currentYear = moment().format('YYYY')
  $scope.holidays = Holiday.query(year: $scope.currentYear)
]
