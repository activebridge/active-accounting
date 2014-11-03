@CounterpartiesCtrl = ['$scope', '$q', '$timeout', 'Counterparty', ($scope, $q, $timeout, Counterparty) ->
  $scope.counterparties = Counterparty.query()

  $('#start_date').datepicker
    dateFormat: 'dd-mm-yy'

  $scope.datepicker = () ->
    $timeout ->
      $('.editable-input').datepicker()

  $scope.add = ->
    counterparty = Counterparty.save($scope.newCounterparty,
      () ->
        counterparty.active = true
        $scope.counterparties.push(counterparty)
        $scope.newCounterparty = {}
    )

  $scope.delete = (counterparty_id) ->
    if confirm('Впевнений?')
      Counterparty.delete
        id: counterparty_id
      , (success) ->
        $scope.counterparties = Counterparty.query()
        return

  $scope.update_ac = (counterparty_id, status) ->
    d = $q.defer()
    console.log(status)
    Counterparty.update( id: counterparty_id, {counterparty: {active: status}}
      () ->
        d.resolve()
      (response) ->
        d.resolve response.data.errors['active'][0]
    )
    return d.promise

  $scope.update = (counterparty_id, name) ->
    d = $q.defer()
    Counterparty.update( id: counterparty_id, {counterparty: {name: name}}
      () ->
        d.resolve()
      (response) ->
        d.resolve response.data.errors['name'][0]
    )
    return d.promise

]
