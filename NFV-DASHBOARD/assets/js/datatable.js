/*
openstack-compute-nodes-table
kubernetes-workers-table
kubernetes-pods-table
openstack-vms-table
 */

(function($) {

  'use strict';

  var datatableInit = function() {

    // var $table = $('#kubernetes-workers-table');
    // $table.dataTable({
    //   dom: '<"row"<"col-lg-6"l><"col-lg-6"f>><"table-responsive"t>p',
    //   bProcessing: true,
    //   sAjaxSource: $table.data('url')
    // });

    var $tables = $('table[id$=-table]');
    $tables.each(function(tableIndex){
      $(this).dataTable({
        dom: '<"row"<"col-lg-6"l><"col-lg-6"f>><"table-responsive"t>p',
        bProcessing: true,
        sAjaxSource: $(this).data('url')
      });
    });

  };

  $(function() {
    datatableInit();
  });

}).apply(this, [jQuery]);
