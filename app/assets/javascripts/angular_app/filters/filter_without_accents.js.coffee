angular.module('InescApp').filter 'filter_without_accents', ->
  clearString = (->
    translate_re = /[àáâãäåæçèéêëìíîïñòóôõöœùúûüýÿ]/g
    translate =
      'à': 'a', 'á': 'a', 'â': 'a', 'ã': 'a', 'ä': 'a', 'å': 'a',
      'æ': 'ae',
      'ç': 'c',
      'è': 'e', 'é': 'e', 'ê': 'e', 'ë': 'e',
      'ì': 'i', 'í': 'i', 'î': 'i', 'ï': 'i',
      'ñ': 'n',
      'ò': 'o', 'ó': 'o', 'ô': 'o', 'õ': 'o', 'ö': 'o',
      'œ': 'oe',
      'ù': 'u', 'ú': 'u', 'û': 'u', 'ü': 'u',
      'ý': 'y', 'ÿ': 'y',

    (string) ->
      string.toLowerCase().replace(translate_re, (match) -> translate[match])
  )()

  isContained = (string, contained) ->
    clearString(string).indexOf(clearString(contained)) != -1

  (values, label) ->
    values.filter (element) ->
      isContained(element.label, label)

