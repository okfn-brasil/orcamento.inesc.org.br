angular.module('InescApp').directive 'treemap', ['openspending', (openspending) ->
  getColorPalette = (num) ->
    ('#3498db' for i in [0...num])

  watchDrilldowns = (treemap, scope) ->
    drilldown = treemap.context.drilldown
    scope.drilledDown = false
    treemap.context.drilldown = (tile) ->
      scope.$apply ->
        scope.drilledDown = true
        drilldown(tile)

  buildGraph = (element, drilldowns, year, scope) ->
    state =
      drilldowns: drilldowns
      cut: "time.year:#{year}"
    context =
      dataset: openspending.dataset
      siteUrl: openspending.url
      embed: true
      click: (node) -> # Não redireciona pro OpenSpending
      hasClick: (node) -> node.data.node.children.length > 0

    deferred = new window.OpenSpending.Treemap(element, context, state)
    deferred.done (treemap) -> watchDrilldowns(treemap, scope)
    deferred

  restrict: 'E',
  scope:
    year: '='
  template: '<button class="btn btn-small back-button" ng-click="reset()" ng-disabled="!drilledDown" ng-class="{visible: drilledDown}">Voltar</button>' +
            '<div id="treemap"></div>' # O OpenSpendingJS exige que o elemento tenha um id
  link: (scope, element, attributes) ->
    window.OpenSpending.Utils.getColorPalette = getColorPalette
    window.OpenSpending.scriptRoot = "#{openspending.url}/static/openspendingjs"
    window.OpenSpending.localeGroupSeparator = ','
    window.OpenSpending.localeDecimalSeparator = '.'

    drilldowns = JSON.parse(attributes.drilldowns)
    treemapElem = $(element).children('div')

    scope.reset = ->
      year = scope.year
      buildGraph(treemapElem, drilldowns, year, scope) if year

    scope.$watch 'year', -> scope.reset()
]

