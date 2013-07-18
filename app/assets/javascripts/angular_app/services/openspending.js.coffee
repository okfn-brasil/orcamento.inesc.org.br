angular.module('InescApp').factory('openspending', ['$http', '$q', ($http, $q) ->
  url = 'http://openspending.org'
  apiUrl = "#{url}/api/2"
  aggregateUrl = "#{apiUrl}/aggregate?callback=JSON_CALLBACK"
  dataset = "orcamento_federal"
  brasil =
    label: "Brasil"
  isBrasil = (entity) -> entity.label == brasil.label

  downloadUrl = (entity) ->
    if isBrasil(entity)
      "#{url}/#{dataset}.csv"
    else
      "#{url}/#{dataset}/#{entity.type}/#{entity.id}/entries.csv?pagesize=1000000"

  get = (entity, year) ->
    parameters =
      dataset: dataset
    parameters.cut = "#{entity.type}:#{entity.id}" if entity.type

    autorizadoParameters =
      dataset: parameters.dataset
      cut: "time.year:#{year}"
      drilldown: "time.month"
      order: "time.month:asc"
    autorizadoParameters.cut += "|#{parameters.cut}" if parameters.cut

    pagoParameters =
      measure: "pago"

    rppagoParameters =
      measure: "rppago"

    yearlyParameters =
      drilldown: "time.year"
      order: "time.year:desc"

    deferred = $q.defer()

    $q.all([
      $http.jsonp(aggregateUrl, { params: autorizadoParameters }),
      $http.jsonp(aggregateUrl, { params: $.extend(autorizadoParameters, pagoParameters) }),
      $http.jsonp(aggregateUrl, { params: $.extend(autorizadoParameters, rppagoParameters) }),
      $http.jsonp(aggregateUrl, { params: $.extend(parameters, yearlyParameters) })
    ]).then (response) ->
      [autorizado, pago, rppago, yearly] = [response[0].data, response[1].data, response[2].data, response[3].data]
      autorizado = $.extend(autorizado, total: autorizado.summary.amount)
      pago = $.extend(pago, total: pago.summary.pago)
      rppago = $.extend(rppago, total: rppago.summary.rppago)
      pagamentos = total: pago.total + rppago.total
      naoExecutado = total: autorizado.total - pagamentos.total
      amounts =
        autorizado: autorizado
        pago: pago
        rppago: rppago
        pagamentos: pagamentos
        naoExecutado: naoExecutado
        yearly: yearly.drilldown
        downloadUrl: downloadUrl(entity)
      deferred.resolve $.extend(entity, amounts)

    deferred.promise

  query: ->
    deferred = $q.defer()
    $http.jsonp("#{aggregateUrl}&dataset=#{dataset}&drilldown=orgao|uo").success (data) ->
      orgaos = []
      unidadesOrcamentarias = []
      data.drilldown.map (element) ->
        # Os órgãos começam do índice 1. Como array começam do 0, tenho que
        # diminuir um elemento, ou o bootstrap tentará acessar um elemento nulo.
        idOrgao = element.orgao.id-1
        idUO = element.uo.id-1
        orgaos[idOrgao] ||=
          id: element.orgao.name
          type: 'orgao'
          label: element.orgao.label
        unidadesOrcamentarias[idUO] =
          id: element.uo.name
          type: 'uo'
          label: element.uo.label
          orgao: orgaos[idOrgao]
      result = orgaos.concat(unidadesOrcamentarias)
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
  getBrasil: (year) ->
    get(brasil, year)
  get: get
  embedUrl: (widgetType, drilldowns, year) ->
    state = "{\"drilldowns\": [#{drilldowns}], \"year\": #{year}}"
    "#{url}/#{dataset}/embed?widget=#{widgetType}&state=#{state}"



])
