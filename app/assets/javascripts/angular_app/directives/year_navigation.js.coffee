angular.module('InescApp').directive 'yearNavigation', ->
  restrict: 'C',
  template: '<select ng-model="year"' +
              'ng-options="thisYear.time.year as thisYear.time.year for thisYear in entity.yearly">' +
            '</select>',
  scope:
    year: '='
    entity: '='

