angular.module('InescApp').filter 'entityUrl', ['routing', (routing) ->
  (entity, year) ->
    routing.generateUrl(entity, year) if entity?
]

