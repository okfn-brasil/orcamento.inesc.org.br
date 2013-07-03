angular.module('InescApp').controller('AppController', ['$scope', ($scope) ->
  $scope.entities = []
  $.getJSON 'http://openspending.org/api/2/aggregate?callback=?&dataset=inesc&drilldown=orgao|unidade_orcamentaria', (data) ->
    result = []
    data.drilldown.map (element) ->
      # Os órgãos começam do índice 1. Como array começam do 0, tenho que
      # diminuir um elemento, ou o bootstrap tentará acessar um elemento nulo.
      result[element.unidade_orcamentaria.id-1] =
        id: element.unidade_orcamentaria.id
        type: 'unidade_orcamentaria'
        label: element.unidade_orcamentaria.label
      result[element.orgao.id-1] =
        id: element.orgao.id
        type: 'orgao'
        label: element.orgao.label
    $scope.entities = result
])
