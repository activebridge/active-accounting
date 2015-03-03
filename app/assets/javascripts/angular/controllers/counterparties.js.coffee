@CounterpartiesCtrl = ['$scope', '$q', '$timeout', 'Counterparty', '$translate', ($scope, $q, $timeout, Counterparty, $translate) ->
  $scope.newCounterparty = {}
  $scope.newCounterparty.errors = {}

  $scope.load = ->
    $scope.activeCounterparties = Counterparty.query(scope: 'active', group: $scope.showGroup)
    $scope.inactiveCounterparties = Counterparty.query(scope: 'inactive', group: $scope.showGroup)

  $('#start_date').datepicker
    dateFormat: 'dd-mm-yy'

  $scope.showGroup = 'Customer'

  $scope.types = [
    { value: "Customer", text: 'Customer' },
    { value: "Vendor", text: 'Vendor' },
    { value: "Other", text: 'Other' }
  ]

  $scope.openDatepicker = ->
    $('.start_date').datepicker({ dateFormat: "dd-mm-yy" }).focus()
    return

  $scope.endOfMonth = ->
    curr_day = new Date().getDate()
    return curr_day >= 25

  $scope.add = ->
    counterparty = Counterparty.save($scope.newCounterparty,
      () ->
        $scope.activeCounterparties.push(counterparty) if $scope.newCounterparty.type == $scope.showGroup
        $scope.newCounterparty = {}
        $('select.сounterparty-types').select2('val', '')
      (response) ->
        $scope.newCounterparty.errors = response.data.error
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
    if data.active != active && active
      data.monthly_payment = false
      $scope.activeCounterparties[index].monthly_payment = false
    return if data.monthly_payment && !data.value_payment
    d = $q.defer()
    Counterparty.update( id: counterparty_id, {counterparty: data}
      () ->
        d.resolve()
        if data.type != $scope.showGroup || data.active != active
          if active
            $scope.inactiveCounterparties.push($scope.activeCounterparties[index]) if data.type == $scope.showGroup
            $scope.activeCounterparties.splice(index,1)
          else
            $scope.activeCounterparties.push($scope.inactiveCounterparties[index]) if data.type == $scope.showGroup
            $scope.inactiveCounterparties.splice(index,1)
      (response) ->
        d.resolve response.data.errors['data'][0]
    )
    return d.promise

  $scope.load()

  $scope.conversionSelect = (conversion) ->
    if conversion
      $('select.сounterparty-types').select2({width: '180px', minimumResultsForSearch: '5'} )
      return

  $scope.changeGroup = (group) ->
    return if $scope.showGroup == group
    $scope.showGroup = group
    $scope.load()

]
