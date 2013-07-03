angular.module('InescApp').filter 'round', ->
  (value, sufix='') ->
    decimalCases = if value > 100
                     0
                   else if value > 10
                     1
                   else
                     2

    value.toFixed(decimalCases).replace('.', ',') + ' ' + sufix

