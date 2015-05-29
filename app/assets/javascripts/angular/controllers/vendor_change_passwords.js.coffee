@VendorChangePasswordsCtrl = ['$scope', 'VendorChangePassword', '$modal', ($scope, VendorChangePassword, $modal) ->
  $scope.vendor = {}

  $scope.changePassword = ->
    VendorChangePassword.change_password($scope.vendor,
      () ->
        $('.info-update').fadeIn().fadeOut(3000)
        $('#change_pass')[0].reset()
        $scope.passwordModal.hide()
      , (response) ->
          $('.error').fadeIn().fadeOut(3000)
    )

  $scope.changePasswordModal = (url) ->
    $scope.passwordModal = $modal(scope: $scope, template: url, show: false)
    $scope.passwordModal.$promise.then $scope.passwordModal.show
]
