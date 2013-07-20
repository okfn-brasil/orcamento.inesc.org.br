angular.module('InescApp').directive 'treemap', ['openspending', (openspending) ->
  getColorPalette = (num) ->
    ('#3498db' for i in [0...num])
  buildGraph = (element, drilldowns, year) ->
    state =
      drilldowns: drilldowns
      cut: "time.year:#{year}"
    context =
      dataset: openspending.dataset
      siteUrl: openspending.url
      embed: true
      click: (node) -> # Não redireciona pro OpenSpending
      hasClick: (node) -> node.data.node.children.length > 0

    new window.OpenSpending.Treemap(element, context, state)

  restrict: 'E',
  scope:
    year: '='
  link: (scope, element, attributes) ->
    window.OpenSpending.Utils.getColorPalette = getColorPalette
    window.OpenSpending.scriptRoot = "#{openspending.url}/static/openspendingjs"
    window.OpenSpending.localeGroupSeparator = ','
    window.OpenSpending.localeDecimalSeparator = '.'

    drilldowns = JSON.parse(attributes.drilldowns)
    treemapElem = $(element)

    scope.$watch 'year', (year) ->
      buildGraph(treemapElem, drilldowns, year)
]

