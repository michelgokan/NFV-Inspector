(function ($) {

  'use strict';

  var columnsOrder = ["id", "sla_id", "traffic_demand_configuration_id", "quality_metric_id", "min_guaranteed_value", "max_guaranteed_value"];
  var url = $("#datatable-editable").data("url");
  var aoColumns = [
    {data: "id"},
    {data: "sla_id"},
    {data: "traffic_demand_configuration_id"},
    {data: "quality_metric_id"},
    {data: "min_guaranteed_value"},
    {data: "max_guaranteed_value"},
    {"bSortable": false, "mData": null}
  ];

  $(function () {
    EditableTable.initialize(columnsOrder, url, aoColumns);
  });


}).apply(this, [jQuery]);
