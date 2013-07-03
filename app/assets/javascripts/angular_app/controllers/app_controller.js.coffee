angular.module('InescApp').controller('AppController', ['$scope', '$routeParams', '$location', 'openspending', ($scope, $routeParams, $location, openspending) ->
    $scope.entities = []
    $scope.year = 2012

    openspending.query().then (entities) -> $scope.entities = entities
    openspending.getTotals().then (totals) -> $scope.totals = totals

    $scope.$watch 'entity.id + year', ->
      [entity, year] = [$scope.entity, $scope.year]
      if entity? and entity.id? and entity.type? and year?
        openspending.get(entity, year).then (entity) -> $scope.entity = entity

    $scope.changeYear = (year) ->
      console.log($routeParams)

    window.s = $scope
])
