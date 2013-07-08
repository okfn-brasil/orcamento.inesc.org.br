angular.module('InescApp').directive 'percentualGraph', ->
  calculateYears = (entity, totals) ->
    years = entity.yearly.map (year) ->
      totalsYear = $.grep(totals.years, (element) -> element.year == year.time.year)[0]
      total = totalsYear.autorizado if totalsYear
      label: year.time.year,
      total: total,
      amount: year.amount
      percentual: calculatePercentual(year.amount, total)
    percentuals = years.map (year) -> year.percentual
    scale = d3.scale.linear()
              .domain([min(percentuals), max(percentuals)])
              .range([1, 100])
    years.map (year) ->
      year.height = scale(year.percentual)
      year

  calculatePercentual = (amount, total) ->
    if total != 0
      parseFloat(((amount * 100) / total).toFixed(2))
    else
      0

  max = (array) ->
    Math.max.apply(Math, array)

  min = (array) ->
    Math.min.apply(Math, array)

  restrict: 'E',
  scope:
    entity: '=',
    totals: '=',
    year: '='
  template: '<div class="span12 bar-graph-box">' +
              '<div class="span4 inner-box">' +
                '<h4>' +
                  'Percentual do total<br/>' +
                  '<small>(referente à <span>{{currentYear.label}}</span>)</small>' +
                '</h4>' +
                '<div class="large-number" title="Representação do orçamento federal"' +
                'ng-bind="currentYear.percentual | percentual"></div>' +
                '<p class="absolute-value"></p>' +
              '</div>' +
              '<div class="span8 inner-box bar-graph">' +
                '<div class="meter" title="{{year.amount | currency:\'R$ \'}}"' +
                'ng-repeat="year in years">' +
                  '<input id="select-year-{{year.label}}" type="radio"' +
                  'ng-value="year.label" ng-model="$parent.$parent.year">' +
                  '<label for="select-year-{{year.label}}">' +
                    '<span class="meter-bar" style="height: {{year.height}}%;"></span>' +
                    '<span class="meter-label" ng-bind="year.label"></span>' +
                  '</label>' +
                '</div>' +
              '</div>' +
            '</div>'
  link: (scope, element, attributes) ->
    scope.$watch 'entity.yearly + totals + year', ->
      [entity, totals, year] = [scope.entity, scope.totals, scope.year]
      if entity? and entity.yearly? and totals? and year?
        scope.years = calculateYears(entity, totals)
        scope.currentYear = $.grep(scope.years, (thisYear) ->
          parseInt(thisYear.label) == parseInt(year)
        )[0]


