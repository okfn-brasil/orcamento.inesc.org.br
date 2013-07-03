angular.module('InescApp').filter 'roundedCurrency', ['$filter', ($filter) ->
  currency = $filter('currency')
  format = (value, sufix='') ->
    decimalCases = if value > 100
                     0
                   else if value > 10
                     1
                   else
                     2

    value.toFixed(decimalCases).replace('.', ',') + ' ' + sufix

  thousand = 1000
  million = thousand * thousand
  billion = million * thousand
  trillion = billion * thousand
  (value) ->
    value = value || 0
    absValue = Math.abs(value)
    if absValue > trillion
      format(value/trillion, 'Tri')
    else if absValue > billion
      format(value/billion, 'Bi')
    else if absValue > million
      format(value/million, 'Mi')
    else if absValue > thousand
      format(value/thousand, 'Mil')
    else if absValue
      format(value)
]

