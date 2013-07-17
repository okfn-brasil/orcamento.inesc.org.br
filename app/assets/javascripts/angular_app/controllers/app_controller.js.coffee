angular.module('InescApp').controller('AppController', ['$scope', 'openspending', 'routing', ($scope, openspending, routing) ->
    currentYear = new Date().getFullYear().toString()
    openspending.query().then (entities) ->
      [entity, year] = routing.parseUrl(entities)
      $scope.entities = entities
      $scope.entity = entity
      $scope.year = year || currentYear
])
