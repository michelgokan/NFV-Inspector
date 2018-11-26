(function ($) {

  'use strict';

  var columnsOrder = ["id", "experiment_set_id",
    "name", "system_function_id", "traffic_demand_configuration_id",
    "node_placement_configuration_id", "start_time", "end_time", "status"];
  var url = $("#datatable-editable").data("url");
  var aoColumns = [
    {data: "id"},
    {data: "experiment_set_id"},
    {data: "name"},
    {data: "system_function_id"},
    {data: "traffic_demand_configuration_id"},
    {data: "node_placement_configuration_id"},
    {data: "start_time"},
    {data: "end_time"},
    {data: "status"},
    {"bSortable": false, "mData": null}
  ];

  $(function () {
    EditableTable.initialize(columnsOrder, url, aoColumns);
  });
}).apply(this, [jQuery]);
