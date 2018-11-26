(function ($) {

  'use strict';

  var columnsOrder = ["id", "experiment_id", "node_id", "resource_allocation_configuration_id", "node_properties_configuration_id", "vnf_properties_configuration_id"];
  var url = $("#datatable-editable").data("url");
  var aoColumns = [
    {data: "id"},
    {data: "experiment_id"},
    {data: "node_id"},
    {data: "resource_allocation_configuration_id"},
    {data: "node_properties_configuration_id"},
    {data: "vnf_properties_configuration_id"},
    {"bSortable": false, "mData": null}
  ];

  $(function () {
    EditableTable.initialize(columnsOrder, url, aoColumns);
  });
}).apply(this, [jQuery]);
