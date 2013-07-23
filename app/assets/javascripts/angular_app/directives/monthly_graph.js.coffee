angular.module('InescApp').directive 'monthlyGraph', ['$filter', ($filter) ->
  buildGraph = (svgElement, entity) ->
     nv.addGraph () ->
         data = processData(entity)
         chart = nv.models.multiChart()
               .x((d,i) -> d.x)
               .color(['#E74C3C','#C0392b','#3498DB'])

         chart.tooltipContent((key, x, y, e, graph) ->
           "<h3>#{key}</h3>" +
           "<p>#{y} em #{x}</p>"
         )

         chart.xAxis.showMaxMin(true).tickFormat((x) ->
           $filter('month')(x)
         )

         chart.yAxis1.showMaxMin(true)
             .tickFormat($filter('roundedCurrency'))

         d3.select(svgElement)
             .datum(data)
           .transition().duration(500).call(chart)

         nv.utils.windowResize(chart.update)

         chart

  processData = (entity) ->
    autorizado = entity.autorizado
    pago = entity.pago
    rppago = entity.rppago
    pagamentos = entity.pagamentos.drilldown

    accumulateAmounts = (values, element) ->
      length = values.length
      amount = if length > 0 then values[length-1].y else 0
      amount += element.amount || element.pago || element.pagamentos || 0
      values.push {
        x: element.time.month,
        y: amount
      }
      values
    [
      {
        key: "Pagamentos",
        yAxis: 1,
        type: "bar",
        values: pagamentos.map (element) -> { x: element.time.month, y: element.pagamentos }
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
]

