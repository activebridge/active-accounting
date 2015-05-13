@CounterpartiesCtrl = ['$scope', '$q', '$timeout', 'Counterparty', 'Invitation', '$translate', ($scope, $q, $timeout, Counterparty, Invitation, $translate) ->
  $scope.newCounterparty = {}
  $scope.newCounterparty.errors = {}

  $scope.load = ->
    $scope.counterpaties = Counterparty.query(group: $scope.showGroup)

  $scope.showGroup = 'Customer'

  $scope.types = [
    { value: "Customer", text: 'Customer' },
    { value: "Vendor", text: 'Vendor' },
    { value: "Other", text: 'Other' }
  ]

  $scope.endOfMonth = ->
    curr_day = new Date().getDate()
    return curr_day >= 25

  $scope.add = ->
    counterparty = Counterparty.save($scope.newCounterparty,
      () ->
        $scope.counterpaties.push(counterparty) if $scope.newCounterparty.type == $scope.showGroup
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

  $scope.setSelect2 = () ->
    $('select.customer-select').select2()
    return

  $scope.cloneCounterparty = (counterparty) ->
    $scope.counterpartyOld = counterparty
    $scope.editCounterparty = {}
    angular.copy(counterparty, $scope.editCounterparty)

  $scope.update = (counterparty) ->
    data = {
      'id': counterparty.id
      'name': counterparty.name
      'start_date': counterparty.start_date
      'monthly_payment': counterparty.monthly_payment
      'value_payment': counterparty.value_payment
      'email': counterparty.email
      'active': counterparty.active
      'customer_id': counterparty.customer_id
      'type': counterparty.type
    }

    d = $q.defer()
    data.customer_id = '' if data.type != $scope.counterpartyOld.type && data.customer_id != ''
    Counterparty.update( id: data.id, { counterparty: data }
      (response) ->
        d.resolve()
        $('.client-info-modal .alert').fadeIn().fadeOut(3000)
        index = $scope.counterpaties.indexOf($scope.counterpartyOld)
        $scope.counterpaties.splice(index, 1, response)
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

  $scope.loadCustumers = () ->
    $scope.activeCustumers = Counterparty.query(scope: 'active', group: 'Customer')
  $scope.loadCustumers()

  $scope.sendInvitation = (id) ->
    Invitation.save
      id: id
    , (response) ->
      $scope.message = response.success
      setTimeout (->
        $scope.$apply ->
          $scope.message = undefined
          return
        return
      ), 5000
]
