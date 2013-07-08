angular.module('InescApp').directive 'tableGraph', ->
  calculateMonths = (entity) ->
    months = {}
    $.each entity.autorizado.drilldown, (i, element) ->
      months[element.time.month] ||= {label: element.time.month}
      months[element.time.month].autorizado = element.amount
    $.each entity.rppago.drilldown, (i, element) ->
      months[element.time.month] ||= {label: element.time.month}
      months[element.time.month].rppago = element['rp-pago']
    $.each entity.pago.drilldown, (i, element) ->
      months[element.time.month] ||= {label: element.time.month}
      months[element.time.month].pago = element.pago
      months[element.time.month].pagamentos = element.pago + months[element.time.month].rppago
    months

  restrict: 'E',
  scope:
    entity: '=',
    totals: '=',
    year: '='
  template: '<h3>O gráfico em números</h3>' +
            '<table class="table graph-numbers">' +
              '<thead>' +
              '<tr>' +
                '<th>Mês</th>' +
                '<th>Autorizado</th>' +
                '<th>Pago</th>' +
                '<th>RP Pago</th>' +
                '<th>Pagamentos (Pago + RP Pago)</th>' +
              '</tr>' +
              '<tbody>' +
              '<tr ng-repeat="month in months">' +
                '<td>{{month.label | month}}</td>' +
                '<td>{{month.autorizado | currency:""}}</td>' +
                '<td>{{month.pago | currency:""}}</td>' +
                '<td>{{month.rppago | currency:""}}</td>' +
                '<td>{{month.pagamentos | currency:""}}</td>' +
              '</tr>' +
              '<tfoot>' +
              '<tr>' +
                '<td>Total</td>' +
                '<td>{{entity.autorizado.total | currency:""}}</td>' +
                '<td>{{entity.pago.total | currency:""}}</td>' +
                '<td>{{entity.rppago.total | currency:""}}</td>' +
                '<td>{{entity.pagamentos.total | currency:""}}</td>' +
              '</tr>' +
              '</tfoot>' +
              '</tbody>' +
              '</table>'

  link: (scope, element, attributes) ->
    scope.$watch 'entity.autorizado', ->
      entity = scope.entity
      if entity? and entity.autorizado?
        scope.months = calculateMonths(entity)



