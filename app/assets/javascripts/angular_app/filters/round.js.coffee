angular.module('InescApp').filter 'round', ->
  (value, sufix='') ->
    absValue = Math.abs(value)
    decimalCases = if absValue > 100
                     0
                   else if absValue > 10
                     1
                   else
                     2

    value.toFixed(decimalCases).replace('.', ',') + ' ' + sufix

