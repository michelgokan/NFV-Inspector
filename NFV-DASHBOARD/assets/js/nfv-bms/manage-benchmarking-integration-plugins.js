(function ($) {

  'use strict';

  var columnsOrder = ["id", "name", "start_endpoint"];
  var url = $("#datatable-editable").data("url");
  var aoColumns = [
    {data: "id"},
    {data: "name"},
    {data: "start_endpoint"},
    {"bSortable": false, "mData": null}
  ];

  $(function () {
    EditableTable.initialize(columnsOrder, url, aoColumns);
  });
}).apply(this, [jQuery]);
