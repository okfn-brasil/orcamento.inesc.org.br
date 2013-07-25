angular.module('InescApp').directive 'asyncErrorMessage', ['_FAILED_REQUEST_', (_FAILED_REQUEST_) ->
  restrict: 'E',
  link: (scope, element, attributes) ->
    elem = $(element)
    scope.$on _FAILED_REQUEST_, -> elem.modal('toggle')
]

