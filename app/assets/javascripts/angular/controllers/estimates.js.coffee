@EstimatesCtrl = ['$scope', '$q', '$translate', 'Estimate', 'Counterparty', 'registerDecorator', ($scope, $q , $translate, Estimate, Counterparty, registerDecorator) ->
  registerDecorator($scope)

  $scope.newEstimate = {}
  $scope.newEstimate.errors = {}

  $scope.estimates = Estimate.query()

  $scope.add = ->
    estimate = Estimate.save($scope.newEstimate,
      () ->
        $scope.estimates.unshift(estimate)
        $scope.newEstimate = {}
        $('select.estimate').select2('val', '')
      (response) ->
        $scope.newEstimate.errors = response.data.error
    )

  $scope.customers = Estimate.customers
    scope: 'active'
    () ->
      $('select.estimate').select2({width: '200px'})

  $scope.delete = (estimate_id, index) ->
    if confirm('Впевнений?')
      Estimate.delete
        id: estimate_id
      , (success) ->
        $scope.estimates.splice(index,1)
        return
  $scope.setNumeric = ->
    $('.number').numeric
      negative: false
      decimal: false
    $('.number').attr('maxlength', '3')
  $scope.setNumeric()

  $('#estimates_form').validate
    errorElement: 'div'
    errorPlacement: (error, element) ->
      error.insertBefore element
      return
    rules:
      'hours': required: true
      'month': required: true
    messages:
      'hours': 'Cant be blank'
      'month': 'Cant be blank'

  $scope.update = (estimate_id, data) ->
    d = $q.defer()
    estimate = Estimate.update( id: estimate_id, {estimate: { hours: data.hours } }
      (response) ->
        d.resolve()
      (response) ->
        d.resolve response.data.errors['hours'][0]
    )
    return d.promise
]
