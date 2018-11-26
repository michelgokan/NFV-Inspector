(function ($) {

  'use strict';

  var columnsOrder = ["id", "name", "deployment_id", "sla_id", "generated_by", "status"];
  var url = $("#datatable-editable").data("url");
  var aoColumns = [
    {data: "id"},
    {data: "name"},
    {data: "deployment_id"},
    {data: "sla_id"},
    {data: "generated_by"},
    {data: "status"},
    {"bSortable": false, "mData": null}
  ];

  $(function () {
    EditableTable.initialize(columnsOrder, url, aoColumns);
  });
}).apply(this, [jQuery]);
