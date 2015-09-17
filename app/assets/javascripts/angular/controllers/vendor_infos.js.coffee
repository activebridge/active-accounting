@VendorInfosCtrl = ['$scope', '$q', 'VendorInfo', ($scope, $q, VendorInfo) ->

  $scope.update = (vendorInfo) ->
    d = $q.defer()
    data = {
      'id': vendorInfo.id
      'name': vendorInfo.name
      'account': vendorInfo.account
      'bank': vendorInfo.bank
      'contract': vendorInfo.contract
      'ipn': vendorInfo.ipn
      'mfo': vendorInfo.mfo
      'address': vendorInfo.address
      'agreement_date': vendorInfo.agreement_date
    }
    VendorInfo.update( id: vendorInfo.id, {vendor_info: data}
      (response) ->
        d.resolve()
        $('.info-update').fadeIn().fadeOut(4000)
        $scope.vendorInfoModal.hide()
      (response) ->
        d.resolve response.vendorInfo.errors['vendorInfo'][0]
    )
    return d.promise
]
