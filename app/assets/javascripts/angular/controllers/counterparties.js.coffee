@CounterpartiesCtrl = ['$scope', '$q', '$timeout', 'Counterparty', ($scope, $q, $timeout, Counterparty) ->
  $scope.load = ->
    $scope.totalActive = 0 

    $scope.counterparties = Counterparty.query
      report_type: 'revenues'
      , (response) ->
        $(response).each (k, v) ->
          $scope.totalActive += 1 if v.active is true
        $(response).each (k, v) ->
          $scope.totalNoActive = v.id if k+1 is $scope.totalActive

  $('#start_date').datepicker
    dateFormat: 'dd-mm-yy'

  $scope.datepicker = () ->
    $timeout ->
      $('.editable-input').datepicker()

  $scope.add = ->
    counterparty = Counterparty.save($scope.newCounterparty,
      () ->
        $scope.counterparties.push(counterparty)
        $scope.load()
    )

  $scope.delete = (counterparty_id) ->
    if confirm('Впевнений?')
      Counterparty.delete
        id: counterparty_id
      , (success) ->
        $scope.counterparties = Counterparty.query()
        return

  $scope.update_status = (counterparty_id, status) ->
    d = $q.defer()
    Counterparty.update( id: counterparty_id, {counterparty: {active: status}}
      () ->
        d.resolve()
        $scope.load()
      (response) ->
        d.resolve response.data.errors['active'][0]
    )
    return d.promise

  $scope.update_name = (counterparty_id, name) ->
    d = $q.defer()
    Counterparty.update( id: counterparty_id, {counterparty: {name: name}}
      () ->
        d.resolve()
      (response) ->
        d.resolve response.data.errors['name'][0]
    )
    return d.promise

  $scope.load()
]
