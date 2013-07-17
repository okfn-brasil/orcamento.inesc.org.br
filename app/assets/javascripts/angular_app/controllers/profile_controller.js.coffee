angular.module('InescApp').controller('ProfileController', ['$scope', 'openspending', 'routing', ($scope, openspending, routing) ->
    openspending.getTotals().then (totals) -> $scope.totals = totals
    $scope.$watch 'entity + year', ->
      [entity, year] = [$scope.entity, $scope.year]
      if entity? and entity.id? and year?
        openspending.get(entity, year).then (entity) -> $scope.entity = entity
        routing.updateRoute(entity, year)
])

