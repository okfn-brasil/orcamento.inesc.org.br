angular.module('InescApp').controller('ProfileController', ['$scope', 'openspending', 'routing', ($scope, openspending, routing) ->
    $scope.tabs =
      monthly:
        active: true
      gnd:
        active: false
      uo:
        active: false

    openspending.getTotals().then (totals) -> $scope.totals = totals
    $scope.$watch 'entity + year', ->
      [entity, year] = [$scope.entity, $scope.year]
      if entity? and entity.id? and year?
        openspending.get(entity, year).then (entity) ->
          $scope.entity = entity
          if entity.type == 'orgao'
            openspending.getUnidadesOrcamentarias(entity, year).then (entity) ->
              $scope.entity = entity
        routing.updateRoute(entity, year)
])

