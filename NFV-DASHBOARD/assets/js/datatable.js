/*
openstack-compute-nodes-table
kubernetes-workers-table
kubernetes-pods-table
openstack-vms-table
 */

(function ($) {

  'use strict';

  var datatableInit = function () {

    // var $table = $('#kubernetes-workers-table');
    // $table.dataTable({
    //   dom: '<"row"<"col-lg-6"l><"col-lg-6"f>><"table-responsive"t>p',
    //   bProcessing: true,
    //   sAjaxSource: $table.data('url')
    // });

    // var $tables = $('table[id$=-table]');
    // $tables.each(function(tableIndex){
    //   $(this).dataTable({
    //     dom: '<"row"<"col-lg-6"l><"col-lg-6"f>><"table-responsive"t>p',
    //     bProcessing: true,
    //     sAjaxSource: $(this).data('url')
    //   });
    // });

    $("#kubernetes-pods-table").dataTable({
      dom: '<"row"<"col-lg-6"l><"col-lg-6"f>><"table-responsive"t>p',
      bProcessing: true,
      sAjaxSource: $("#kubernetes-pods-table").data('url'),
      "rowCallback": function (row, data) {
        var pod_name = $('td:first', row).html();
        $('td:first', row).html("<a href='/NFV-MON/kubernetes/resource-usage?pod_name=" + pod_name + "&show_live=1'>" + pod_name + "</a>");
      }
    });

    $("#kubernetes-workers-table").dataTable({
      dom: '<"row"<"col-lg-6"l><"col-lg-6"f>><"table-responsive"t>p',
      bProcessing: true,
      sAjaxSource: $("#kubernetes-workers-table").data('url')
    });

    $("#openstack-vms-table").dataTable({
      dom: '<"row"<"col-lg-6"l><"col-lg-6"f>><"table-responsive"t>p',
      bProcessing: true,
      sAjaxSource: $("#openstack-vms-table").data('url')
    });

    $("#openstack-compute-nodes-table").dataTable({
      dom: '<"row"<"col-lg-6"l><"col-lg-6"f>><"table-responsive"t>p',
      bProcessing: true,
      sAjaxSource: $("#openstack-compute-nodes-table").data('url')
    });


  };

  $(function () {
    datatableInit();
  });

}).apply(this, [jQuery]);
