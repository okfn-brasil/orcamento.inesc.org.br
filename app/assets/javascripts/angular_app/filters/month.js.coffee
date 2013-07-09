angular.module('InescApp').filter 'month', ->
  months = ['Jan', 'Fev', 'Mar', 'Abr',
            'Mai', 'Jun', 'Jul', 'Ago',
            'Set', 'Out', 'Nov', 'Dez']
  (month) ->
    index = parseInt(month) - 1
    months[index]
