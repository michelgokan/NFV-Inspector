(function ($) {

  'use strict';

  var columnsOrder = ["id", "name", "start_parameter"];
  var url = $("#datatable-editable").data("url");
  var aoColumns = [
    {data: "id"},
    {data: "name"},
    {data: "start_parameter"},
    {"bSortable": false, "mData": null}
  ];

  $(function () {
    EditableTable.initialize(columnsOrder, url, aoColumns);
  });
}).apply(this, [jQuery]);
