angular.module('InescApp').factory('openspending', ['$http', '$q', ($http, $q) ->
  url = 'http://openspending.org/api/2'
  aggregateUrl = "#{url}/aggregate?callback=JSON_CALLBACK"
  query: ->
    deferred = $q.defer()
    $http.jsonp("#{aggregateUrl}&dataset=inesc&drilldown=orgao|unidade_orcamentaria").success (data) ->
      result = []
      data.drilldown.map (element) ->
        # Os órgãos começam do índice 1. Como array começam do 0, tenho que
        # diminuir um elemento, ou o bootstrap tentará acessar um elemento nulo.
        result[element.unidade_orcamentaria.id-1] =
          id: element.unidade_orcamentaria.name
          type: 'unidade_orcamentaria'
          label: element.unidade_orcamentaria.label
        result[element.orgao.id-1] =
          id: element.orgao.name
          type: 'orgao'
          label: element.orgao.label
      deferred.resolve(result)
    deferred.promise
])
