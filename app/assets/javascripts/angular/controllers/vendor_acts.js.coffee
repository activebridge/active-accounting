@VendorActsCtrl = ['$scope', '$http', '$translate', '$modal', '$cookies', ($scope, $http, $translate, $modal, $cookies) ->
  $scope.actParams = {
    month: moment().format('MM/YYYY')
  }

  $scope.showCreateActModal = (url) ->
    $scope.extraOptions.translation = 0
    $scope.createActModal = $modal(scope: $scope, template: url, show: false)
    $scope.createActModal.$promise.then $scope.createActModal.show

  $scope.changeSelect = ->
    $http.get("vendor_acts?vendor_id=#{$scope.actParams.id}").success(
      (response) ->
        $scope.acts = response.acts
        $scope.currentVendor = response.vendor
        $("#generated-act-vendor").html ''
        $scope.buttonExport = false
        $scope.infoActEmpty = true if response.acts.length == 0
    )

  displayAct = (response) ->
    $("#generated-act-vendor").html response
    $scope.idShowAct = $('#vendor_act_id').text()
    $scope.buttonExport = true
    $scope.infoActEmpty = false
    $scope.acts = []

  errorResponse = (response) ->
    messages = ''
    lengthMessages = response.messages.length
    $.each response.messages, (k, v)->
      messages += $translate.instant(v)
      messages += ', ' if k != lengthMessages - 1 && k != 0
    alert messages
    $("#generated-act-vendor").html ''

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
]
