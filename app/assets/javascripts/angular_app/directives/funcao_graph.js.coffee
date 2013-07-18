angular.module('InescApp').directive 'funcaoGraph', ['openspending', (openspending) ->
  restrict: 'E',
  template: '<iframe class="funcao-treemap" frameborder="0"></iframe>',
  scope:
    year: '='
  link: (scope, element, attributes) ->
    iframe = $(element).children('iframe')
    scope.$watch 'year', ->
      year = scope.year
      if year
        url = openspending.embedUrl('treemap', attributes.drilldowns, year)
        iframe.attr('src', url)
]

