angular.module('InescApp').controller('IndexController', ['$scope', 'openspending', 'routing', ($scope, openspending, routing) ->
    $scope.$watch 'year', ->
      year = $scope.year
      if year?
        openspending.getBrasil(year).then (brasil) ->
          $scope.brasil = brasil
          routing.updateRoute(undefined, year)

    $scope.$watch 'entity + year', ->
      [entity, year] = [$scope.entity, $scope.year]
      if entity? and entity.id and year
        routing.updateRoute(entity, year)
])

