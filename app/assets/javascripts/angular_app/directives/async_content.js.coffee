angular.module('InescApp').directive 'asyncContent', ['_START_REQUEST_', '_END_REQUEST_', (_START_REQUEST_, _END_REQUEST_) ->
  restrict: 'A',
  link: (scope, element, attributes) ->
    spinner = new Spinner()

    scope.$on _START_REQUEST_, -> spinner.spin(element[0])
    scope.$on _END_REQUEST_, -> spinner.stop()
]

