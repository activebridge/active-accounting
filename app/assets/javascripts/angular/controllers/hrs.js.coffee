@HrsCtrl = ['$scope', '$q', '$translate', 'Counterparty', ($scope, $q , $translate, Counterparty) ->
  $scope.vendors = Counterparty.query(group: 'vendor')
]
