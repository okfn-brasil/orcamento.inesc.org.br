angular.module('InescApp').filter 'roundedCurrency', ['$filter', ($filter) ->
  currency = $filter('currency')
  format = (value, sufix) ->
    currency(value, 'R$ ').replace('.', ',') + ' ' + sufix

  thousand = 1000
  million = thousand * thousand
  billion = million * thousand
  trillion = billion * thousand
  (value) ->
    if value > trillion
      format(value/trillion, 'Tri')
    else if value > billion
      format(value/billion, 'Bi')
    else if value > million
      format(value/million, 'Mi')
    else if value > thousand
      format(Math.round(value/thousand), 'Mil')
]

