angular.module('InescApp').directive 'monthlyGraph', ->
  buildGraph = (svgElement, entity) ->
     nv.addGraph () ->
         data = processData(entity)
         chart = nv.models.multiChart()
               .x((d,i) -> parseInt(d.x))
               .color(['#E74C3C','#C0392b','#3498DB'])

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

  processData = (entity) ->
    autorizado = entity.autorizado
    pago = entity.pago
    rppago = entity.rppago

    accumulateAmounts = (values, element) ->
      length = values.length
      amount = if length > 0 then values[length-1].y else 0
      amount += element.amount || element.pago || 0
      values.push {
        x: element.time.month,
        y: amount
      }
      values

    pagamentos = pago.drilldown.map (element, i) ->
      rppago_amount = rppago.drilldown[i]["rp-pago"]
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
        values: autorizado.drilldown.reduce(accumulateAmounts, [])
      },
    ]

  restrict: 'A',
  scope:
    entity: '=',
    year: '='
  link: (scope, element, attributes) ->
    scope.$watch 'entity.autorizado', ->
      [entity, year] = [scope.entity, scope.year]
      if entity? and entity.autorizado? and year?
        buildGraph(element[0], entity)

