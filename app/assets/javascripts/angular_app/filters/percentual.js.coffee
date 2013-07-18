angular.module('InescApp').filter 'percentual', ['$filter', ($filter) ->
  round = $filter('round')
  (value) ->
    round(value || 0, '%')
]

