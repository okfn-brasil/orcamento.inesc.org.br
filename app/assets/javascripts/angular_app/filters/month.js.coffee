angular.module('InescApp').filter 'month', ->
  (month) ->
    switch month
      when '01' then 'Jan'
      when '02' then 'Fev'
      when '03' then 'Mar'
      when '04' then 'Abr'
      when '05' then 'Mai'
      when '06' then 'Jun'
      when '07' then 'Jul'
      when '08' then 'Ago'
      when '09' then 'Set'
      when '10' then 'Out'
      when '11' then 'Nov'
      when '12' then 'Dez'
