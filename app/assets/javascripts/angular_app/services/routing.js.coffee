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
        if window.history && window.history.pushState && (!entity || !inRootPage())
          window.history.pushState({}, '', newUrl)
          ga('send', 'pageview')
        else
          window.location.pathname = newUrl
    parseUrl: (entities) ->
      path = window.location.pathname
      uoRegexp = /^\/(.+)\/(.+)\/([0-9]{4})$/
      orgaoRegexp = /^\/(.+)\/([0-9]{4})$/
      anoRegexp = /^\/([0-9]{4})$/

      id = undefined
      year = undefined

      if match = uoRegexp.exec(path)
        id = slugToId(match[2])
        type = 'uo'
        year = match[3]
      else if match = orgaoRegexp.exec(path)
        id = slugToId(match[1])
        type = 'orgao'
        year = match[2]
      else if match = anoRegexp.exec(path)
        year = match[1]

      entity = if id
        (entities.filter (entity) -> parseInt(entity.id) == id && entity.type == type)[0]
      [entity, year]
    generateUrl: generateUrl
])

