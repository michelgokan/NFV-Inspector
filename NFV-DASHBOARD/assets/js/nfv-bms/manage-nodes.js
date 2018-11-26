(function ($) {

  'use strict';

  var columnsOrder = ["id", "type_id", "name", "vnf_id"];
  var url = $("#datatable-editable").data("url");
  var aoColumns = [
    {data: "id"},
    {data: "type_id"},
    {data: "name"},
    {data: "vnf_id"},
    {"bSortable": false, "mData": null}
  ];

  $(function () {
    EditableTable.initialize(columnsOrder, url, aoColumns);
  });


}).apply(this, [jQuery]);
