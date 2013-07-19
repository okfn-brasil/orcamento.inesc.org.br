angular.module('InescApp').directive 'uoGraph', ['$filter', ($filter) ->
  columns = [
    { sTitle: 'Entidade Orçamentária', bSortable: false },
    { sTitle: 'Orçamento Autorizado', bSortable: false }
  ]

  processData = (data, year) ->
    data.map (uo) ->
      entityUrl = $filter('entityUrl')
      currency = $filter('currency')
      console.log(uo)
      ["<a href='#{entityUrl(uo, year)}'>#{uo.label}</a>",
        currency(uo.amount, '')]

  options =
    bPaginate: false
    aaSorting: [[ 1, 'desc' ]]

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
        scope.data = processData(entity.unidades_orcamentarias, year)

]

