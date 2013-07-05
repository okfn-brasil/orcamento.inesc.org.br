angular.module('InescApp').factory('openspending', ['$http', '$q', ($http, $q) ->
  url = 'http://openspending.org/api/2'
  aggregateUrl = "#{url}/aggregate?callback=JSON_CALLBACK"
  dataset = "inesc"

  query: ->
    deferred = $q.defer()
    $http.jsonp("#{aggregateUrl}&dataset=#{dataset}&drilldown=orgao|unidade_orcamentaria").success (data) ->
      result = []
      data.drilldown.map (element) ->
        # Os órgãos começam do índice 1. Como array começam do 0, tenho que
        # diminuir um elemento, ou o bootstrap tentará acessar um elemento nulo.
        result[element.orgao.id-1] =
          id: element.orgao.name
          type: 'orgao'
          label: element.orgao.label
        result[element.unidade_orcamentaria.id-1] =
          id: element.unidade_orcamentaria.name
          type: 'unidade_orcamentaria'
          label: element.unidade_orcamentaria.label
          orgao: result[element.orgao.id-1]
      deferred.resolve(result)
    deferred.promise
  getTotals: ->
    deferred = $q.defer()
    $http.jsonp("#{aggregateUrl}&dataset=#{dataset}&drilldown=time.year").success (data) ->
      years = data.drilldown.map (element) ->
        year: element.time.year
        autorizado: element.amount
      totals =
        years: years
        autorizado: data.summary.amount
      deferred.resolve(totals)
    deferred.promise
  get: (entity, year) ->
    autorizadoParameters =
      dataset: dataset
      cut: "time.year:#{year}|#{entity.type}:#{entity.id}"
      drilldown: "time.month|#{entity.type}"
      order: "time.month:asc"

    pagoParameters =
      measure: "pago"

    rppagoParameters =
      measure: "rp-pago"

    deferred = $q.defer()

    $q.all([
      $http.jsonp(aggregateUrl, { params: autorizadoParameters }),
      $http.jsonp(aggregateUrl, { params: $.extend(autorizadoParameters, pagoParameters) }),
      $http.jsonp(aggregateUrl, { params: $.extend(autorizadoParameters, rppagoParameters) })
    ]).then (response) ->
      [autorizado, pago, rppago] = [response[0].data, response[1].data, response[2].data]
      autorizado = $.extend(autorizado, total: autorizado.summary.amount)
      pagamentos = total: pago.summary.pago + rppago.summary['rp-pago']
      naoExecutado = total: autorizado.total - pagamentos.total
      amounts =
        autorizado: autorizado
        pago: pago
        rppago: rppago
        pagamentos: pagamentos
        naoExecutado: naoExecutado
      deferred.resolve $.extend(amounts, entity)

    deferred.promise


])
