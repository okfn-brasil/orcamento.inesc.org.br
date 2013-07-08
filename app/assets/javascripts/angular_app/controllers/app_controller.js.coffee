angular.module('InescApp').controller('AppController', ['$scope', 'openspending', ($scope, openspending) ->
    $scope.entities = []
    $scope.year = 2012

    openspending.query().then (entities) ->
      $scope.entities = entities
      parseUrl()
    openspending.getTotals().then (totals) -> $scope.totals = totals

    $scope.$watch 'entity.id + year', ->
      [entity, year] = [$scope.entity, $scope.year]
      if entity? and entity.id? and entity.type? and year?
        openspending.get(entity, year).then (entity) -> $scope.entity = entity
        updateRoute()

    updateRoute = ->
      newUrl = generateUrl($scope.entity, $scope.year)
      if window.location.pathname != newUrl
        if window.history && !inRootPage()
          window.history.pushState({}, '', newUrl)
        else
          window.location.pathname = newUrl

    parseUrl = ->
      return if inRootPage()
      path = window.location.pathname.substr(1)
      parts = path.split('/')
      id = if parts.length == 3
             slugToId(parts[1]) # É uma unidade orçamentária
           else
             slugToId(parts[0]) # É um órgão

      $scope.entity = entity for entity in $scope.entities when parseInt(entity.id) is id
      $scope.year = parseInt(parts[parts.length-1])

    inRootPage = () ->
      window.location.pathname == '/'

    generateUrl = (entity, year) ->
      entitySlug = slugify(entity)
      if entity.orgao?
        orgaoSlug = slugify(entity.orgao)
        "/#{orgaoSlug}/#{entitySlug}/#{year}"
      else
        "/#{entitySlug}/#{year}"

    slugToId = (slug) ->
      parseInt(slug)

    slugify = (entity) ->
      slug = "#{entity.id}-#{entity.label}"
      slug = slug.trim().toLowerCase()

      # remove accents, swap ñ for n, etc
      from = "àáäâãèéëêìíïîòóöôõùúüûñç·/_,:;"
      to   = "aaaaaeeeeiiiiooooouuuunc------"
      for char, i in from
        slug = slug.replace(new RegExp(char, 'g'), to.charAt(i))

      slug = slug.replace(/[^a-z0-9 -]/g, '') # remove invalid chars
                 .replace(/\s+/g, '-') # collapse whitespace and replace by -
                 .replace(/-+/g, '-'); # collapse dashes

])
