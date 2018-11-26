(function ($) {

  'use strict';

  var columnsOrder = ["id", "name", "duration", "rate", "distribution"];
  var url = $("#datatable-editable").data("url");
  var aoColumns = [
    {data: "id"},
    {data: "name"},
    {data: "duration"},
    {data: "rate"},
    {data: "distribution"},
    {"bSortable": false, "mData": null}
  ];

  $(function () {
    EditableTable.initialize(columnsOrder, url, aoColumns);
  });


}).apply(this, [jQuery]);
