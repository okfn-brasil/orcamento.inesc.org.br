angular.module('InescApp').filter 'roundedCurrency', ['$filter', ($filter) ->
  round = $filter('round')

  thousand = 1000
  million = thousand * thousand
  billion = million * thousand
  trillion = billion * thousand

  (value) ->
    absValue = Math.abs(value || 0)
    if absValue > trillion
      round(value/trillion, ' Tri')
    else if absValue > billion
      round(value/billion, ' Bi')
    else if absValue > million
      round(value/million, ' Mi')
    else if absValue > thousand
      round(value/thousand, ' Mil')
    else
      round(value)
]

