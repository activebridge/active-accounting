#= require jquery
#= require jquery_ujs
#= require highcharts
#= require jquery.validate
#= require jquery.validate.additional-methods
#= require bootstrap-sprockets
#= require jquery-ui
#= require turbolinks
#= require angular.min
#= require angular-resource.min
#= require angular-js
#= require angular/directives
#= require angular/routes
#= require angular/modules
#= require_tree ./angular/controllers
#= require_tree ./angular/decorators
#= require_tree .

_.mixin
  capitalize: (string) ->
    string.charAt(0).toUpperCase() + string.substring(1).toLowerCase()
