@CounterpartiesCtrl = ['$scope', '$q', '$timeout', 'Counterparty', 'Invitation', '$translate', '$modal', 'counterpartyDecorator', ($scope, $q, $timeout, Counterparty, Invitation, $translate, $modal, counterpartyDecorator) ->
  counterpartyDecorator($scope)
  $scope.newCounterparty = {}
  $scope.newCounterparty.errors = {}
  $scope.counterparty = {}

  $scope.parseVersions = (content) ->
    return angular.fromJson("#{content}")

  $scope.showClientInfoModal = (counterparty, url) ->
    $scope.clientInfoModal = $modal(scope: $scope, template: url, show: false)
    $scope.counterparty = counterparty
    $scope.clientInfoModal.$promise.then $scope.clientInfoModal.show

  $scope.showEditCounterpartyModal = (counterparty, url) ->
    $scope.editCounterpartyModal = $modal(scope: $scope, template: url, show: false)
    $scope.counterparty = counterparty
    $scope.editCounterpartyModal.$promise.then $scope.editCounterpartyModal.show

  $scope.showVendorInfoModal = (counterparty, url) ->
    $scope.vendorInfoModal = $modal(scope: $scope, template: url, show: false)
    $scope.counterparty = counterparty
    $scope.vendorInfoModal.$promise.then $scope.vendorInfoModal.show

  $scope.loadedData = {}

  $scope.load = ->
    if !!$scope.loadedData[$scope.showGroup]
      $scope.counterpaties = $scope.loadedData[$scope.showGroup]
    else
      $scope.counterpaties = Counterparty.query(group: $scope.showGroup)
      $scope.loadedData[$scope.showGroup] = $scope.counterpaties

  $scope.showGroup = 'Customer'

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

  $scope.delete = (counterparty) ->
    if confirm('Впевнений?')
      Counterparty.delete
        id: counterparty.id
      , (success) ->
        index = $scope.counterpaties.indexOf(counterparty)
        $scope.counterpaties.splice(index, 1)

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
      'currency_monthly_payment': counterparty.currency_monthly_payment
    }

    d = $q.defer()
    data.customer_id = '' if data.type != $scope.counterpartyOld.type && data.customer_id != ''
    Counterparty.update( id: data.id, { counterparty: data }
      (response) ->
        d.resolve()
        $('.info-update').fadeIn().fadeOut(4000)
        $scope.editCounterpartyModal.hide()
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
    $scope.loadCustumers() if group == 'Vendor'
    return if $scope.showGroup == group
    $scope.showGroup = group
    $scope.load()

  $scope.loadCustumers = () ->
    $scope.activeCustumers = Counterparty.query
      scope: 'active'
      group: 'Customer'
      () ->
        $scope.activeCustumers.unshift({ id: '', name: $translate.instant('without_customer') })
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

  $scope.isVendorType = (model) ->
    return $scope.specialTypes.indexOf(model.type) > -1
]
