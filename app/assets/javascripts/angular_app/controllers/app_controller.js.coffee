angular.module('InescApp').controller('AppController', ['$scope', 'openspending', ($scope, openspending) ->
  openspending.query().then (entities) -> $scope.entities = entities
])
