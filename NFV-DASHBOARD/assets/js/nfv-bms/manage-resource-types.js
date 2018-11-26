(function ($) {

  'use strict';

  var columnsOrder = ["id", "name", "min_cap", "max_cap"];
  var url = $("#datatable-editable").data("url");
  var aoColumns = [
    {data: "id"},
    {data: "name"},
    {data: "min_cap"},
    {data: "max_cap"},
    {"bSortable": false, "mData": null}
  ];

  $(function () {
    EditableTable.initialize(columnsOrder, url, aoColumns);
  });


}).apply(this, [jQuery]);
