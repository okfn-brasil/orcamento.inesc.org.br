angular.module('InescApp').directive 'monthlyGraph', ['$filter', ($filter) ->
  chart = undefined

  buildOrUpdateGraph = (chart, svgElement, entity) ->
    if chart
      updateGraph(chart, svgElement, entity)
    else
      buildGraph(svgElement, entity)

  buildGraph = (svgElement, entity) ->
     nv.addGraph () ->
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

         updateGraph(chart, svgElement, entity)

  updateGraph = (chart, svgElement, entity) ->
    data = processData(entity)
    d3.select(svgElement)
        .datum(data)
      .transition().duration(500).call(chart)

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
        x: parseInt(element.time.month)
        y: amount
      }
      values
    [
      {
        key: "Pagamentos",
        yAxis: 1,
        type: "bar",
        values: pagamentos.map (element) -> { x: parseInt(element.time.month), y: element.pagamentos }
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
      entity = scope.entity
      if entity? and entity.autorizado?
        buildOrUpdateGraph(chart, element[0], entity)
]

