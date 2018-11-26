(function ($) {

  'use strict';

  var columnsOrder = ["id", "node_placement_configuration_id", "node_id", "parent_node_id", "description"];
  var url = $("#datatable-editable").data("url");
  var aoColumns = [
    {data: "id"},
    {data: "node_placement_configuration_id"},
    {data: "node_id"},
    {data: "parent_node_id"},
    {data: "description"},
    {"bSortable": false, "mData": null}
  ];

  $(function () {
    EditableTable.initialize(columnsOrder, url, aoColumns);
  });


}).apply(this, [jQuery]);
