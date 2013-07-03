angular.module('InescApp', ['ui.bootstrap'], ['$routeProvider', '$locationProvider', ($routeProvider, $locationProvider) ->
  $routeProvider.when(':entity/:year',
    controller: ($scope, $routeParams) ->
      console.log('roteou'))
  $locationProvider.html5Mode(true)
])
