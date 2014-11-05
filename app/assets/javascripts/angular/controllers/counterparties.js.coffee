@CounterpartiesCtrl = ['$scope', '$q', '$timeout', 'Counterparty', ($scope, $q, $timeout, Counterparty) ->
  $scope.load = ->
    $scope.counterparties = Counterparty.query({}, (response) ->
      q = undefined
      $(response).each (k, v) ->
        q = 0  if k is 0
        q += 1  if v.active is true
      $(response).each (k, v) ->
        $scope.totalNoActive = v.id  if k + 1 is q
    )

  $('#start_date').datepicker
    dateFormat: 'dd-mm-yy'

  $scope.datepicker = () ->
    $timeout ->
      $('.editable-input').datepicker()

  $scope.add = ->
    counterparty = Counterparty.save($scope.newCounterparty,
      () ->
        $scope.counterparties.push(counterparty)
        $scope.newCounterparty = {}
        $scope.load()
    )

  $scope.delete = (counterparty_id) ->
    if confirm('Впевнений?')
      Counterparty.delete
        id: counterparty_id
      , (success) ->
        $scope.counterparties = Counterparty.query()
        return

  $scope.update = (counterparty_id, data) ->
    d = $q.defer()
    Counterparty.update( id: counterparty_id, {counterparty: data}
      () ->
        d.resolve()
        $scope.load()
      (response) ->
        d.resolve response.data.errors['data'][0]
    )
    return d.promise

  $scope.load()
]
