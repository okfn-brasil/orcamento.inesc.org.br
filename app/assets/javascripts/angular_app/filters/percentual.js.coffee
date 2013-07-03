angular.module('InescApp').filter 'percentual', ['$filter', ($filter) ->
  round = $filter('round')
  (value, total) ->
    if value? and total?
      percentual = (value * 100) / total
      round(percentual, '%')
]

