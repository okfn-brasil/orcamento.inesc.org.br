angular.module('InescApp').controller('AppController', ['$scope', '$q', 'openspending', 'routing', ($scope, $q, openspending, routing) ->
    $q.all([
      openspending.getTotals(),
      openspending.query(),
    ]).then (response) ->
      [totals, entities] = [response[0], response[1]]
      $scope.totals = totals
      latestYearWithData = totals.years[0].year
      [entity, year] = routing.parseUrl(entities)
      $scope.entities = entities
      $scope.entity = entity
      $scope.year = year || latestYearWithData

    $scope.$watch 'entity + year', ->
      [entity, year] = [$scope.entity, $scope.year]
      if entity? and entity.id and year
        routing.updateRoute(entity, year)
])
