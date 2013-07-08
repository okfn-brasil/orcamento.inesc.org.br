angular.module('InescApp').filter 'month', ->
  (month) ->
    month = parseInt(month)
    switch month
      when 1 then 'Jan'
      when 2 then 'Fev'
      when 3 then 'Mar'
      when 4 then 'Abr'
      when 5 then 'Mai'
      when 6 then 'Jun'
      when 7 then 'Jul'
      when 8 then 'Ago'
      when 9 then 'Set'
      when 10 then 'Out'
      when 11 then 'Nov'
      when 12 then 'Dez'
