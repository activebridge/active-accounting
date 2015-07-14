@VendorOrdersCtrl = ['$scope', '$http', '$translate', 'OrderFeatures', '$modal', '$q', ($scope, $http, $translate, OrderFeatures, $modal, $q) ->
  $scope.orderParams = {
    month: moment().format('MM/YYYY')
  }

  defaultParams = ->
    $scope.newFeatures = {}
    $scope.newFeaturesModal = {}
    $scope.errorShow = {}
    $scope.errorShowModal = {}
    $scope.idFeature = {}
    $scope.selectShow =
      Primary: true
      Additional: true

  defaultParams()

  $scope.indexGroup =
      Primary: 1
      Additional: 2

  $scope.setSelect2ForFeatures = (key) ->
    $scope.idFeature[key] = ''
    $("select#addFeture#{key}.features-select").select2({width: '500px', minimumResultsForSearch: '3', dropdownCssClass: "dropdown-fetuatures" }).select2('val', '')
    return

  $scope.hideCurrentOrder = ->
    $scope.showCurrentOrder = false

  addVirtualFeature = (features) ->
    $.each ['Additional','Primary'], (k, type) ->
      data =
        type: type
        typeVirtual: true
        name: 'virtual feature'
        id: "virtual #{type}"
      features.unshift(data)

  $scope.allFeatures = OrderFeatures.query(
    () ->
      addVirtualFeature($scope.allFeatures)
  )

  $scope.showOrder = (order) ->
    $scope.showCurrentOrder = true
    defaultParams()
    addVirtualFeature(order.features)
    $scope.currentOrder = order
    showFeatures(order.features)

  $scope.addFeature = (key) ->
    if $scope.idFeature[key] == 'newFeature'
      $scope.selectShow[key] = false
    else
      OrderFeatures.get
        id: $scope.idFeature[key],
        vendor_order_id: $scope.currentOrder.id,
        (response) ->
          $scope.currentOrder.features.push(response)
          findFeature = _.find $scope.allFeatures, (feature) ->
            feature.id == response.id
          findFeature.show = false
          return

  featureInAllOrders = (currentFeature, options = {}) ->
    if $scope.orders
      $.each $scope.orders, (k, v) ->
        findFeature = _.find v.features, (feature) ->
          feature.id == currentFeature.id
        index = v.features.indexOf(findFeature)
        if index > -1
          if options.updated
            v.features.splice(index, 1, currentFeature)
          else
            v.features.splice(index, 1)

  $scope.deleteFeature = (feature, options = {}) ->
    if confirm('Впевнений?')
      data =
        id: feature.id
      data.vendor_order_id = $scope.currentOrder.id if options.orderId
      OrderFeatures.delete(data
        () ->
          features =
            if options.orderId
              $scope.currentOrder.features
            else
              $scope.allFeatures
          featureInAllOrders(feature) unless options.orderId
          index = features.indexOf(feature)
          features.splice(index, 1) if index > -1
          if options.orderId
            findFeature = _.find $scope.allFeatures, (oneFeature) ->
              oneFeature.id == feature.id
            findFeature.show = true
      )

  $scope.createFeature = (key, newFeatures, errors, options = {}) ->
    newFeature =
      type: key
      name: newFeatures[key]
    data =
      feature : newFeature
    data.vendor_order_id = $scope.currentOrder.id if options.orderId
    feature = OrderFeatures.save(data,
      () ->
        feature.show = true unless options.orderId
        $scope.currentOrder.features.push(feature) if options.orderId
        $scope.allFeatures.push(feature)
        newFeatures[key] = ''
        $scope.selectShow[key] = true if options.orderId
        errors[key] = false
      , (response) ->
        errors[key] = true
    )

  $scope.canselCreateFeature = (key) ->
    $scope.errorShow[key] = false
    $scope.selectShow[key] = true
    $scope.idFeature[key] = ''
    $("select#addFeture#{key}.features-select").select2('val', '')
    return

  showFeatures = (features) ->
    $.each $scope.allFeatures, (k, currentFeature) ->
      findFeature = _.find features, (feature) ->
        feature.id == currentFeature.id
      currentFeature.show = !findFeature
      currentFeature

  $scope.showListFeaturesModal = (url) ->
    $scope.ListFeaturesModal = $modal(scope: $scope, template: url, show: false)
    $scope.ListFeaturesModal.$promise.then $scope.ListFeaturesModal.show

  $scope.changeSelect = ->
    $scope.currentVendor = _.find $scope.vendors, (vendor) ->
      parseInt($scope.orderParams.id) == vendor.id
    $scope.currentVendor.start_date = $scope.currentVendor.start_date.split("-").join(".")
    $http.get("vendor_orders?vendor_id=#{$scope.orderParams.id}").success(
      (response) ->
        $scope.orders = response
        $scope.showCurrentOrder = false
    )

  $scope.updateFeature = (feature_id, data) ->
    d = $q.defer()
    feature = OrderFeatures.update( id: feature_id, {feature: data}
      (response) ->
        featureInAllOrders(feature, options = { updated: true })
        d.resolve()
      (response) ->
        d.resolve response.error.name[0]
    )
    return d.promise

  $scope.createOrder = ->
    data =
      month: $scope.orderParams.month
      vendor_id: $scope.orderParams.id
    $http.post('vendor_orders/', data).success(
      (response) ->
        $scope.currentOrder = response
        addVirtualFeature($scope.currentOrder.features)
        showFeatures($scope.currentOrder.features)
        $scope.showCurrentOrder = true
        $scope.orders.unshift(response)
        defaultParams()
    ).error (response) ->
      messages = ''
      lengthMessages = response.messages.length
      $.each response.messages, (k, v)->
        messages += $translate.instant(v)
        messages += ', ' if k != lengthMessages - 1 && k != 0
      alert messages
]
