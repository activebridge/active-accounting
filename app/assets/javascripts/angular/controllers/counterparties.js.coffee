@CounterpartiesCtrl = ['$scope', '$q', '$timeout', 'Counterparty', ($scope, $q, $timeout, Counterparty) ->
  $scope.load = ->
    $scope.activeCounterparties = Counterparty.query(scope: 'active')
    $scope.inactiveCounterparties = Counterparty.query(scope: 'inactive')

  $('#start_date').datepicker
    dateFormat: 'dd-mm-yy'

  $scope.datepicker = () ->
    $timeout ->
      $('.editable-input').datepicker
        dateFormat: 'dd-mm-yy'

  $scope.add = ->
    counterparty = Counterparty.save($scope.newCounterparty,
      () ->
        $scope.activeCounterparties.push(counterparty)
        $scope.newCounterparty = {}
    )

  $scope.delete = (counterparty_id, employment) ->
    alert('Контрагент використовується в риєстрі. Видалення може порушити структуру БД!!!') if employment is true
    if confirm('Впевнений?')
      Counterparty.delete
        id: counterparty_id
      , (success) ->
        $scope.load()
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
