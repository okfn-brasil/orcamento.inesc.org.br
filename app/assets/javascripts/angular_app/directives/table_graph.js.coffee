angular.module('InescApp').directive 'tableGraph', ['$filter', ($filter) ->
  columns = [
    { sTitle: 'Mês', bSortable: false }
    { sTitle: 'Autorizado (em R$)', bSortable: false }
    { sTitle: 'Pago (em R$)', bSortable: false }
    { sTitle: 'RP Pago (em R$)', bSortable: false }
    { sTitle: 'Pagamentos (Pago + RP Pago, em R$)', bSortable: false }
    { sTitle: 'Mês', bVisible: false } # Usado só para sorting
  ]

  options =
    bPaginate: false
    aaSorting: [[ 5, 'asc' ]]
    sDom: 't'

  processData = (entity) ->
    monthFilter = $filter('month')
    currencyFilter = $filter('currency')
    months = []
    $.each entity.autorizado.drilldown, (i, element) ->
      month = parseInt(element.time.month)
      months[month] ||= {label: element.time.month}
      months[month].autorizado = element.amount
    $.each entity.rppago.drilldown, (i, element) ->
      month = parseInt(element.time.month)
      months[month] ||= {label: element.time.month}
      months[month].rppago = element.rppago
    $.each entity.pago.drilldown, (i, element) ->
      month = parseInt(element.time.month)
      months[month] ||= {label: element.time.month}
      months[month].pago = element.pago
      months[month].pagamentos = element.pago + months[month].rppago
    months.push
      label: 'Total'
      autorizado: entity.autorizado.total
      pago: entity.pago.total
      rppago: entity.rppago.total
      pagamentos: entity.pagamentos.total
    months.splice(1).map (month, i) ->
      [monthFilter(month.label)
        currencyFilter(month.autorizado, '')
        currencyFilter(month.pago, '')
        currencyFilter(month.rppago, '')
        currencyFilter(month.pagamentos, '')
        month.label]

  restrict: 'E',
  scope:
    entity: '=',
    totals: '=',
    year: '='
  template: '<h3>O gráfico em números</h3>' +
            '<my-data-table class="table graph-numbers" columns="columns" options="options" data="data"></my-data-table>' +
            '<a class="btn btn-large btn-block data-download-cta ng-href="{{entity.downloadUrl}}">' +
              '<span class="icon-download icon-large">' +
                'Baixar planilha com os dados <small>(em formato .CSV)</small>' +
              '</span>' +
            '</a>',
  link: (scope, element, attributes) ->
    scope.columns = columns
    scope.options = options
    scope.$watch 'entity.autorizado', ->
      entity = scope.entity
      if entity? and entity.autorizado?
        scope.data = processData(entity)
        window.d = scope.data
        console.log(scope.data)
]

