(function ($) {

  'use strict';

  var columnsOrder = ["id", "quality_metric_labeling_configuration_id", "quality_metric_id", "label", "lower_bound", "upper_bound"];
  var url = $("#datatable-editable").data("url");
  var aoColumns = [
    {data: "id"},
    {data: "quality_metric_labeling_configuration_id"},
    {data: "quality_metric_id"},
    {data: "label"},
    {data: "lower_bound"},
    {data: "upper_bound"},
    {"bSortable": false, "mData": null}
  ];

  $(function () {
    EditableTable.initialize(columnsOrder, url, aoColumns);
  });


}).apply(this, [jQuery]);
