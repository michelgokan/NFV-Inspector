(function ($) {

  'use strict';

  var columnsOrder = ["id", "vnf_id", "resource_type_id", "min_cap", "max_cap"];
  var url = $("#datatable-editable").data("url");
  var aoColumns = [
    {data: "id"},
    {data: "vnf_id"},
    {data: "resource_type_id"},
    {data: "min_cap"},
    {data: "max_cap"},
    {"bSortable": false, "mData": null}
  ];

  $(function () {
    EditableTable.initialize(columnsOrder, url, aoColumns);
  });


}).apply(this, [jQuery]);
