angular.module('InescApp').directive 'gndGraph', ['$filter', ($filter) ->
  columns = [
    { sTitle: 'Grupo da Natureza da Despesa', bSortable: false }
    { sTitle: 'Orçamento Autorizado', bSortable: false, sClass: 'currency' }
    { sTitle: 'Percentual do Total', bSortable: false, sClass: 'percentual' }
    { sTitle: 'Orçamento Autorizado', bVisible: false } # Usado só pra sorting
  ]
  options =
    bPaginate: false
    aaSorting: [[ 3, 'desc' ]]
    sDom: 't'

  roundedCurrency = $filter('roundedCurrency')
  currency = $filter('currency')
  percentual = $filter('percentual')

  buildGraph = (svgElement, data, scope) ->
    nv.addGraph ->
      data = [processData(data)]
      chart = nv.models.pieChart()
                .showLabels(false)
                .x((d) -> d.key)
                .y((d) -> d.y)
                .values((d) -> d)
                .color(['#E67E22', '#1ABC9C', '#9B59B6', '#2980B9', '#7F8C8D', '#34495E', '#E74C3C', '#F1C40F'])

      chart.legend.align = false
      chart.tooltipContent((key, x, y, e, graph) ->
        "<h3>#{key}</h3>" +
        "<p>#{roundedCurrency(y.value, 'R$')}</p>"
      )

      d3.select(svgElement)
        .datum(data)
        .transition().duration(1200).call(chart)

      scope.$watch 'active', (active) ->
        chart.update() if active

      chart

  processData = (data) ->
    data.map (d) ->
      key: d.gnd.label
      y: d.amount

  processDataForTable = (entity) ->
    gnd = entity.gnd
    console.log(entity)
    processData(gnd).map (d) ->
      [d.key
       currency(d.y, '')
       percentual((d.y*100)/entity.autorizado.total)
       d.y]

  restrict: 'E'
  template: '<svg></svg>' +
            '<h3>O gráfico em números</h3>' +
            '<my-data-table columns="columns" options="options" data="data"></my-data-table>' +
            '<a ng-href="{{entity.downloadUrl}}" class="btn btn-large btn-block data-download-cta">' +
              '<span class="icon-download icon-large">' +
                ' Baixar planilha com os dados <small>(em formato .CSV)</small>' +
              '</span>' +
            '</a>'
  scope:
    entity: '='
    active: '='
  link: (scope, element, attributes) ->
    scope.columns = columns
    scope.options = options
    svg = $(element).children('svg')[0]
    scope.$watch 'entity.gnd', ->
      entity = scope.entity
      if entity? and entity.gnd?
        buildGraph(svg, entity.gnd, scope)
        scope.data = processDataForTable(entity)
]
