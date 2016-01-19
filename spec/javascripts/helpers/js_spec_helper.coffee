beforeEach ->
  module('accounting.services')

  inject ($httpBackend, $compile, $rootScope, $controller, $location, $injector, $timeout) ->
    @scope = $rootScope.$new()
    @http = $httpBackend
    @compile = $compile
    @location = $location
    @controller = $controller
    @injector = $injector
    @timeout = $timeout
    @model = (name) =>
      @injector.get(name)
    @eventLoop =
      flush: =>
        @scope.$digest()

afterEach ->
  @http.resetExpectations()
  @http.verifyNoOutstandingExpectation()
