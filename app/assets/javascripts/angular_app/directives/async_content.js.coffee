angular.module('InescApp').directive 'asyncContent', ['_START_REQUEST_', '_END_REQUEST_', (_START_REQUEST_, _END_REQUEST_) ->
  restrict: 'A',
  link: (scope, element, attributes) ->
    spinner = new Spinner( color: '#2C3E50' )
    elem = $(element)
    cssClass = 'loading'

    scope.$on _START_REQUEST_, ->
      spinner.spin(element[0])
      elem.addClass(cssClass)
    scope.$on _END_REQUEST_, ->
      spinner.stop()
      elem.removeClass(cssClass)
]

