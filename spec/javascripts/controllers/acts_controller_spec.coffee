#= require ../helpers/js_spec_helper.coffee

describe 'ActsCtrl', ->
  beforeEach ->
    @controller('ActsCtrl', $scope: @scope)

  describe '$scope.grade', ->
    it '$scope', ->
      expect(@scope.actParams.month).toBe moment().format('MM/YYYY')

  describe 'create Act', ->
    beforeEach ->
      @scope.actParams.id = 1
      date_params = $.param({month: @scope.actParams.month})
      @url = 'acts/' + @scope.actParams.id + '?id=' + @scope.actParams.id + '&' + date_params


    describe 'when user has hours', ->
      it 'response success', ->
        @http.expectGET(@url).respond(200)
        @scope.createAct()
        @http.flush()

        expect(@scope.buttonExport).toBeTruthy()
        expect(@scope.infoActEmpty).toBeFalsy()

    describe 'create Act when user has not hours', ->
      it 'response error', ->
        @http.expectGET(@url).respond(500)
        @scope.createAct()
        @http.flush()

        expect(@scope.buttonExport).toBeFalsy()
        expect(@scope.infoActEmpty).toBeTruthy()
