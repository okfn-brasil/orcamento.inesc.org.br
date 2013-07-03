angular.module('InescApp').directive 'monthlyGraph', ->
  fetchData = (orgao, ano) ->
    openspendingUrl = "http://openspending.org/api/2/aggregate?callback=?"
    autorizadoParameters =
      dataset: "inesc"
      cut: "time.year:#{ano}|orgao:#{orgao.id}"
      drilldown: "orgao|time.month"
      order: "time.month:asc"

    pagoParameters =
      measure: "pago"

    rppagoParameters =
      measure: "rp-pago"

    $.when(
      $.getJSON(openspendingUrl, autorizadoParameters),
      $.getJSON(openspendingUrl, $.extend(autorizadoParameters, pagoParameters)),
      $.getJSON(openspendingUrl, $.extend(autorizadoParameters, rppagoParameters))
    )

  buildGraph = (svgElement) -> (autorizado, pago, rppago) ->
     nv.addGraph () ->
         data = processData(autorizado, pago, rppago)
         chart = nv.models.multiChart()
               .x((d,i) -> parseInt(d.x))
               .color(d3.scale.category20c().range())

         chart.xAxis.showMaxMin(true).tickFormat((d) ->
           index = d - 1
           dx = data[0].values[index] && data[0].values[index].x
           d3.time.format('%b')(new Date(dx))
         )

         chart.yAxis1.showMaxMin(true)
             .tickFormat(d3.format(',s.2'))

         d3.select(svgElement)
             .datum(data)
           .transition().duration(500).call(chart)

         nv.utils.windowResize(chart.update)

         chart

  processData = (autorizado, pago, rppago) ->
    accumulateAmounts = (values, element) ->
      length = values.length
      amount = if length > 0 then values[length-1].y else 0
      amount += element.amount || element.pago || 0
      values.push {
        x: element.time.month,
        y: amount
      }
      values

    pagamentos = pago[0].drilldown.map (element, i) ->
      rppago_amount = rppago[0].drilldown[i]["rp-pago"]
      element.amount = element.pago + rppago_amount
      element

    [
      {
        key: "Pagamentos",
        yAxis: 1,
        type: "bar",
        values: pagamentos.map (element) -> { x: element.time.month, y: element.amount }
      },
      {
        key: "Pagamentos Acumulados",
        yAxis: 1,
        type: "line",
        values: pagamentos.reduce(accumulateAmounts, [])
      },
      {
        key: "Autorizado",
        yAxis: 1,
        type: "area",
        values: autorizado[0].drilldown.reduce(accumulateAmounts, [])
      },
    ]

  restrict: 'A',
  scope:
    entity: '=',
    year: '='
  link: (scope, element, attributes) ->
    scope.$watch 'entity.id + year', ->
      [entity, year] = [scope.entity, scope.year]
      if entity? and entity.id? and entity.type? and year?
        fetchData(entity, year).then(buildGraph(element[0]))

