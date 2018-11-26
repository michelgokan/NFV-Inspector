(function ($) {

  'use strict';

  var columnsOrder = ["id", "name", "quality_metric_type", "upper_bound", "lower_bound"];
  var url = $("#datatable-editable").data("url");
  var aoColumns = [
    {data: "id"},
    {data: "name"},
    {data: "quality_metric_type"},
    {data: "upper_bound"},
    {data: "lower_bound"},
    {"bSortable": false, "mData": null}
  ];

  $(function () {
    EditableTable.initialize(columnsOrder, url, aoColumns);
  });


}).apply(this, [jQuery]);
