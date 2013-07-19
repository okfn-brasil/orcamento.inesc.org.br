angular.module('InescApp').directive 'uoGraph', ['$filter', ($filter) ->
  columns = [
    { sTitle: '#', bSortable: false }
    { sTitle: 'Entidade Orçamentária', bSortable: false }
    { sTitle: 'Orçamento Autorizado', bSortable: false, sClass: 'currency' }
    { sTitle: 'Percentual do total', bSortable: false, sClass: 'percentual' }
    { sTitle: 'Orçamento Autorizado', bVisible: false } # Usado só para sorting
  ]

  options =
    bPaginate: false
    aaSorting: [[ 3, 'desc' ]]
    sDom: 'ft'
    fnRowCallback: (nRow, aData, iDisplayIndex) ->
      $('td:eq(0)', nRow).html(iDisplayIndex + 1)
      nRow

  processData = (entity, year) ->
    entityUrl = $filter('entityUrl')
    currency = $filter('currency')
    percentual = $filter('percentual')
    entity.unidades_orcamentarias.map (uo) ->
      [""
       "<a href='#{entityUrl(uo, year)}'>#{uo.label}</a>"
       currency(uo.amount, '')
       percentual((uo.amount*100)/entity.autorizado.total)
       uo.amount]

  restrict: 'E',
  template: '<my-data-table columns="columns" options="options" data="data"></my-data-table>',
  scope:
    entity: '='
    year: '='
  link: (scope, element, attributes) ->
    scope.columns = columns
    scope.options = options
    scope.$watch 'entity.unidades_orcamentarias + year', ->
      [entity, year] = [scope.entity, scope.year]
      if entity? && entity.unidades_orcamentarias && year
        scope.data = processData(entity, year)
]

