@VendorActsCtrl = ['$q', '$scope', '$http', '$translate', '$modal', '$cookies', 'VendorActs', ($q, $scope, $http, $translate, $modal, $cookies, VendorActs) ->
  $scope.actParams = {
    month: moment().format('MM/YYYY')
  }

  $scope.showCreateActModal = (url) ->
    $scope.extraOptions.translation = 0
    $scope.createActModal = $modal(scope: $scope, template: url, show: false)
    $scope.createActModal.$promise.then $scope.createActModal.show

  $scope.changeSelect = () ->
    $scope.currentVendor = _.find $scope.vendors, (vendor) ->
      parseInt($scope.actParams.id) == vendor.id
    $scope.acts = VendorActs.query(
      vendor_id: $scope.currentVendor.id
      () ->
        $("#generated-act-vendor").html ''
        $scope.showCurrentAct = false
        $scope.infoActEmpty = $scope.acts.length == 0
    )

  displayAct = (response) ->
    $("#generated-act-vendor").html response
    $scope.idShowAct = $('#vendor_act_id').text()
    $scope.showCurrentAct = true
    $scope.infoActEmpty = false

  errorResponse = (response) ->
    $("#generated-act-vendor").html ''
    $.each response.messages, (key, array)->
      messages = if key == 'you_must_fill_fields'
        $translate.instant(key)
      else
        ''
      $.each array, (index, value)->
        messages += $translate.instant(value)
        messages += ', ' if index != array.length - 1
      alert messages

  $scope.extraOptions =
    translation: 0
    rateDollar: $cookies.rateDollar || 0

  $scope.createAct = ->
    $scope.extraOptions.month = $scope.actParams.month
    $scope.extraOptions.vendor_id = $scope.actParams.id
    $http.post('vendor_acts/', $scope.extraOptions).success(
      (response) ->
        $scope.createActModal.hide()
        displayAct(response)
        $scope.acts = VendorActs.query(vendor_id: $scope.currentVendor.id)
    ).error (response) ->
      $scope.createActModal.hide()
      errorResponse(response)
      response

  $scope.showAct = (id) ->
    $http.get('vendor_acts/' + id).success(
      (response) ->
        displayAct(response)
    ).error (response) ->
      errorResponse(response)

  $scope.changeRateDollar = ->
    $cookies.rateDollar = $scope.extraOptions.rateDollar.replace(',','.')

  $scope.hideCurrentAct = ->
    $scope.showCurrentAct = false

  $scope.updateAct = (id, data) ->
    d = $q.defer()
    VendorActs.update(id: id, { total_money: data }
      (response) ->
        d.resolve()
      (response) ->
        d.resolve(response.data.errors)

    )
    return d.promise

  $scope.showCreateActButton = () ->
    return $scope.acts && $scope.actParams.id && $scope.acts.length >= 0

  $scope.showActsRegistry = () ->
    return $scope.acts && !$scope.showCurrentAct && $scope.acts.length > 0
]
