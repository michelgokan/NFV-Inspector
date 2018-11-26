(function ($) {

  'use strict';

  var columnsOrder = ["id", "name", "quality_metric_labeling_configuration_id"];
  var url = $("#datatable-editable").data("url");
  var aoColumns = [
    {data: "id"},
    {data: "name"},
    {data: "quality_metric_labeling_configuration_id"},
    {"bSortable": false, "mData": null}
  ];

  $(function () {
    EditableTable.initialize(columnsOrder, url, aoColumns);
  });


}).apply(this, [jQuery]);
