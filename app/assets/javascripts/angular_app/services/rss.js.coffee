angular.module('InescApp').factory 'rss', ['$q', '$rootScope', ($q, $rootScope) ->
  get: (url, limit) ->
    deferred = $q.defer()

    google.load 'feeds', '1', 'callback': ->
      feed = new google.feeds.Feed(url)
      feed.setNumEntries(limit) if limit
      feed.load (result) ->
        if result.error
          deferred.reject(result.error)
        else
          deferred.resolve(result.feed)
        $rootScope.$digest()

    deferred.promise
]
