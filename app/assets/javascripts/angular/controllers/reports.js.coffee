@ReportsCtrl = ['$scope', 'Report', ($scope, Report) ->
  $scope.by_type_items = Report.query
    report_type: 'by_type'

  $scope.by_article_items = Report.query
    report_type: 'by_article'
]
