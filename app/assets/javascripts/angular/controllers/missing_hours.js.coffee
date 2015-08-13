@MissingHoursCtrl = ['$scope', '$q', 'MissingHours', ($scope, $q, MissingHours) ->
  $scope.users = MissingHours.query()
]
