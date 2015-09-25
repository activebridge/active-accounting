describe 'ArticlesCtrl', ->
  beforeEach ->
    @url = '/articles?type=Revenue'
    @http.expectGET(@url).respond(200)
    @controller('ArticlesCtrl', $scope: @scope)
    @http.flush()

  describe '$scope', ->
    it 'statics', ->
      expect(@scope.showGroup).toBe('Revenue')
      expect(@scope.newArticle.errors).not.toBeUndefined()

  describe '.changeGroup', ->
    beforeEach ->
      @url = '/articles?type=testGroup'
      @http.expectGET(@url).respond(200)

    it 'set $scope.showGroup', ->
      loadFixtures('article_fixture.html')
      @scope.changeGroup('testGroup')
      @http.flush()
      expect(@scope.showGroup).toBe('testGroup')
      expect(@scope.load).not.toBeUndefined()
      expect($('#fixture')).toContainElement('.select2-container')
