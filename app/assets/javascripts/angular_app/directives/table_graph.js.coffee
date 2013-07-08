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
                  '<th>Autorizado (em R$)</th>' +
                  '<th>Pago (em R$)</th>' +
                  '<th>RP Pago (em R$)</th>' +
                  '<th>Pagamentos (Pago + RP Pago, em R$)</th>' +
                '</tr>' +
              '</thead>' +
              '<tbody>' +
                '<tr ng-repeat="month in months">' +
                  '<td>{{month.label | month}}</td>' +
                  '<td class="number-value">{{month.autorizado | currency:""}}</td>' +
                  '<td class="number-value">{{month.pago | currency:""}}</td>' +
                  '<td class="number-value">{{month.rppago | currency:""}}</td>' +
                  '<td class="number-value">{{month.pagamentos | currency:""}}</td>' +
                '</tr>' +
              '</tbody>' +
              '<tfoot>' +
                '<tr>' +
                  '<td>Total</td>' +
                  '<td class="number-value">{{entity.autorizado.total | currency:""}}</td>' +
                  '<td class="number-value">{{entity.pago.total | currency:""}}</td>' +
                  '<td class="number-value">{{entity.rppago.total | currency:""}}</td>' +
                  '<td class="number-value">{{entity.pagamentos.total | currency:""}}</td>' +
                '</tr>' +
              '</tfoot>' +
            '</table>'

  link: (scope, element, attributes) ->
    scope.$watch 'entity.autorizado', ->
      entity = scope.entity
      if entity? and entity.autorizado?
        scope.months = calculateMonths(entity)



