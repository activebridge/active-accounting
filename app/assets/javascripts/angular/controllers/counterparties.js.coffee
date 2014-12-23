@CounterpartiesCtrl = ['$scope', '$q', '$timeout', 'Counterparty', '$translate', ($scope, $q, $timeout, Counterparty, $translate) ->
  $scope.load = ->
    $scope.activeCounterparties = Counterparty.query(scope: 'active')
    $scope.inactiveCounterparties = Counterparty.query(scope: 'inactive')

  $('#start_date').datepicker
    dateFormat: 'dd-mm-yy'

  $scope.openDatepicker = ->
    $('.start_date').datepicker({ dateFormat: "dd-mm-yy" }).focus()
    return

  $scope.add = ->
    counterparty = Counterparty.save($scope.newCounterparty,
      () ->
        $scope.activeCounterparties.push(counterparty)
        $scope.newCounterparty = {}
    )

  $scope.delete = (counterparty_id, index, active) ->
    if confirm('Впевнений?')
      Counterparty.delete
        id: counterparty_id
      , (success) ->
        if active
          $scope.activeCounterparties.splice(index,1)
        else
          $scope.inactiveCounterparties.splice(index,1)
        return

  $scope.update = (counterparty_id, data, index, active) ->
    d = $q.defer()
    Counterparty.update( id: counterparty_id, {counterparty: data}
      () ->
        d.resolve()
        if data.active != active
          if active
            $scope.inactiveCounterparties.push($scope.activeCounterparties[index])
            $scope.activeCounterparties.splice(index,1)
          else
            $scope.activeCounterparties.push($scope.inactiveCounterparties[index])
            $scope.inactiveCounterparties.splice(index,1)
      (response) ->
        d.resolve response.data.errors['data'][0]
    )
    return d.promise

  $scope.load()

]
