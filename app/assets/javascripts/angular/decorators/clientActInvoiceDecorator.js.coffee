angular.module('accounting.services').factory 'clientActInvoiceDecorator', ['$translate', ($translate) ->
  ($scope) ->
    errorMessages = (value, key, length) ->
      messages = ''
      messages += $translate.instant(value)
      messages += ', ' if key != length - 1 && key != 0
      messages

    $scope.errorResponse = (response) ->
      angular.forEach(response.data.messages, (m) ->
        messages = ''
        lengthMessages = m.length
        angular.forEach(m, (v, k) ->
          if typeof(v) == 'object'
            angular.forEach(v, (value, key) ->
              messages += errorMessages(value, key, v.length)
            )
          else
            messages += errorMessages(v, k, lengthMessages)
        )
        alert messages
      )
]
