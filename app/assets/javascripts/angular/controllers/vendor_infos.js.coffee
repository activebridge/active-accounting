@VendorInfosCtrl = ['$scope', '$q', 'VendorInfo', ($scope, $q, VendorInfo) ->

  $scope.update = (vendorInfo) ->
    d = $q.defer()
    VendorInfo.update( id: vendorInfo.id, {vendor_info: vendorInfo}
      (response) ->
        d.resolve()
        $('.info-update').fadeIn().fadeOut(4000)
      (response) ->
        d.resolve response.vendorInfo.errors['vendorInfo'][0]
    )
    return d.promise
]
