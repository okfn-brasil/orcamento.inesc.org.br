angular.module('InescApp').factory('routing', ['openspending', (openspending) ->
    inRootPage = ->
      window.location.pathname.split('/').length <= 2
    isUO = (entity) -> entity.orgao?

    generateUrl = (entity, year) ->
      return "/#{year}" if !entity?
      entitySlug = slugify(entity)
      if isUO(entity)
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

    updateRoute: (entity, year) ->
      newUrl = generateUrl(entity, year)
      if window.location.pathname != newUrl
        if window.history && (!entity || !inRootPage())
          window.history.pushState({}, '', newUrl)
        else
          window.location.pathname = newUrl
    parseUrl: (entities) ->
      path = window.location.pathname.substr(1)
      parts = path.split('/')
      id = if parts.length == 3
             slugToId(parts[1]) # É uma unidade orçamentária
           else if parts.length == 2
             slugToId(parts[0]) # É um órgão

      entity = if id
        (entities.filter (entity) -> parseInt(entity.id) == id)[0]
      year = parts[parts.length-1] || undefined
      [entity, year]
])

