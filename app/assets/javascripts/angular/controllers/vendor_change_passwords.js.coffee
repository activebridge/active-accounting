@VendorChangePasswordsCtrl = ['$scope', 'VendorChangePassword', ($scope, VendorChangePassword) ->
  $scope.vendor = {}

  $scope.change_password = ->
    VendorChangePassword.change_password($scope.vendor,
      () ->
        $('.client-info-modal .alert').fadeIn().fadeOut(3000)
        $('#change_pass')[0].reset()
      , (response) ->
          $('.error').fadeIn().fadeOut(3000)
    )
]
