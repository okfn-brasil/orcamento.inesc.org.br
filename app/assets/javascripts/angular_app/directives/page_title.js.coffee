angular.module('InescApp').directive 'pageTitle', ['$rootScope', ($rootScope) ->
  restrict: 'C',
  link: (scope, element, attributes) ->
    scope.$watch (-> element[0].innerHTML), (newVal, oldVal) ->
      $rootScope.title = newVal
]

