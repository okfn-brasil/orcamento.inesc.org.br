angular.module('InescApp').directive 'gndGraph', ['$filter', ($filter) ->
  roundedCurrency = $filter('roundedCurrency')

  buildGraph = (svgElement, data) ->
    nv.addGraph ->
      data = processData(data)
      chart = nv.models.pieChart()
                .showLabels(false)
                .x((d) -> d.key)
                .y((d) -> d.y)
                .values((d) -> d)

      chart.tooltipContent((key, x, y, e, graph) ->
        "<h3>#{key}</h3>" +
        "<p>#{roundedCurrency(y.value, 'R$')}</p>"
      )

      d3.select(svgElement)
        .datum(data)
        .transition().duration(1200).call(chart)
      chart

  processData = (data) ->
    values = data.map (d) ->
      key: d.gnd.label
      y: d.amount
    [values]

  restrict: 'E'
  template: '<svg></svg>'
  scope:
    entity: '='
  link: (scope, element, attributes) ->
    svg = $(element).children('svg')[0]
    scope.$watch 'entity.gnd', ->
      entity = scope.entity
      buildGraph(svg, entity.gnd) if entity? and entity.gnd?
]
