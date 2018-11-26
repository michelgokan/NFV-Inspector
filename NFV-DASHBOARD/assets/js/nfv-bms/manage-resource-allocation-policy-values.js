(function ($) {

  'use strict';

  var columnsOrder = ["id", "resource_allocation_configuration_id", "resource_type_id", "size_value", "limit_value"];
  var url = $("#datatable-editable").data("url");
  var aoColumns = [
    {data: "id"},
    {data: "resource_allocation_configuration_id"},
    {data: "resource_type_id"},
    {data: "size_value"},
    {data: "limit_value"},
    {"bSortable": false, "mData": null}
  ];

  $(function () {
    EditableTable.initialize(columnsOrder, url, aoColumns);
  });


}).apply(this, [jQuery]);
