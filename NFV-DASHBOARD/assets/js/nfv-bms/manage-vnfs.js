/*
Name: 			Tables / Editable - Examples
Written by: 	Okler Themes - (http://www.okler.net)
Theme Version: 	2.1.1
*/

(function ($) {

  'use strict';

  var actions = [
    '<a href="#" class="hidden on-editing save-row"><i class="fas fa-save"></i></a>',
    '<a href="#" class="hidden on-editing cancel-row"><i class="fas fa-times"></i></a>',
    '<a href="#" class="on-default edit-row"><i class="fas fa-pencil-alt"></i></a>',
    '<a href="#" class="on-default remove-row"><i class="far fa-trash-alt"></i></a>'
  ].join(' ');

  var columnsOrder = ["id", "name"];
  var url = "http://127.0.0.1:3001/api/vnfs";

  var EditableTable = {

    options: {
      addButton: '#addToTable',
      table: '#datatable-editable',
      dialog: {
        wrapper: '#dialog',
        cancelButton: '#dialogCancel',
        confirmButton: '#dialogConfirm',
      }
    },

    initialize: function () {
      this
        .setVars()
        .build()
        .events();
    },

    setVars: function () {
      this.$table = $(this.options.table);
      this.$addButton = $(this.options.addButton);

      // dialog
      this.dialog = {};
      this.dialog.$wrapper = $(this.options.dialog.wrapper);
      this.dialog.$cancel = $(this.options.dialog.cancelButton);
      this.dialog.$confirm = $(this.options.dialog.confirmButton);

      return this;
    },

    build: function () {
      this.datatable = this.$table.DataTable({
        dom: '<"row"<"col-lg-6"l><"col-lg-6"f>><"table-responsive"t>p',
        aoColumns: [
          {data: "id"},
          {data: "name"},
          {"bSortable": false, "mData": null}
        ],
        bProcessing: true,
        "ajax": {
          "url": this.$table.data('url'),
          "dataSrc": ""
        },
        "rowCallback": function (row, data) {
          if (!$(row).hasClass("adding")) {
            $(row).attr("data-item-id", data.id);
            $('td:last', row).html(actions).addClass('actions');
          }
        }
      });

      window.dt = this.datatable;

      return this;
    },

    events: function () {
      var _self = this;

      this.$table
        .on('click', 'a.save-row', function (e) {
          e.preventDefault();

          _self.rowSave($(this).closest('tr'));
        })
        .on('click', 'a.cancel-row', function (e) {
          e.preventDefault();

          _self.rowCancel($(this).closest('tr'));
        })
        .on('click', 'a.edit-row', function (e) {
          e.preventDefault();

          _self.rowEdit($(this).closest('tr'));
        })
        .on('click', 'a.remove-row', function (e) {
          e.preventDefault();

          var $row = $(this).closest('tr'),
            itemId = $row.attr('data-item-id'),
            rowID = $row.data("item-id");

          $.magnificPopup.open({
            items: {
              src: _self.options.dialog.wrapper,
              type: 'inline'
            },
            preloader: false,
            modal: true,
            callbacks: {
              change: function () {
                _self.dialog.$confirm.on('click', function (e) {
                  e.preventDefault();

                  $.ajax({
                    url: url + "/" + rowID,
                    type: 'DELETE',
                    accepts: {
                      mycustomtype: "application/json"
                    },
                    success: function (response, textStatus, jqXhr) {
                      _self.datatable.ajax.reload(function () {
                        var $actions = $row.find('td.actions');
                        if ($actions.get(0)) {
                          _self.rowSetActionsDefault($row);
                        }

                        _self.datatable.draw();
                      });
                    },
                    error: function (jqXHR, textStatus, errorThrown) {
                      alert("Error: " + textStatus + " / " + errorThrown);
                    },
                    complete: function () {
                    }
                  });

                  $.magnificPopup.close();
                });
              },
              close: function () {
                _self.dialog.$confirm.off('click');
              }
            }
          });
        });

      this.$addButton.on('click', function (e) {
        e.preventDefault();

        _self.rowAdd();
      });

      this.dialog.$cancel.on('click', function (e) {
        e.preventDefault();
        $.magnificPopup.close();
      });

      return this;
    },

    // ==========================================================================================
    // ROW FUNCTIONS
    // ==========================================================================================
    rowAdd: function () {
      this.$addButton.attr({'disabled': 'disabled'});

      var data,
        $row;

      var newRow = [];

      columnsOrder.forEach(function (element) {
        newRow[element] = '';
      });

      newRow.push(actions);

      data = this.datatable.row.add(newRow);
      $row = this.datatable.row(data[0]).nodes().to$();

      $row
        .addClass('adding')
        .find('td:last')
        .addClass('actions');

      this.rowEdit($row);

      this.datatable.order([0, 'asc']).draw(); // always show fields
    },

    rowCancel: function ($row) {
      var _self = this,
        $actions,
        i,
        data;

      if ($row.hasClass('adding')) {
        this.rowRemove($row);
      } else {

        data = this.datatable.row($row.get(0)).data();
        this.datatable.row($row.get(0)).data(data);

        $actions = $row.find('td.actions');
        if ($actions.get(0)) {
          this.rowSetActionsDefault($row);
        }

        this.datatable.draw();
      }
    },

    rowEdit: function ($row) {
      var _self = this,
        data, columns;

      data = this.datatable.row($row.get(0)).data();
      columns = this.datatable.settings().init().aoColumns;

      $row.children('td').each(function (i) {
        var $this = $(this);
        var columnId;

        for (var j = 0; j < columns.length; j++) {
          if (columns[i].data === columnsOrder[j]) {
            columnId = j;
            break;
          }
        }

        if ($this.hasClass('actions')) {
          _self.rowSetActionsEditing($row);
        } else {
          $this.html('<input type="text" class="form-control input-block" value="' + data[columnsOrder[columnId]] + '" ' + (i == 0 ? "disabled" : "") + '/>');
        }
      });
    },

    rowSave: function ($row) {
      var _self = this,
        $actions,
        values = [];


      var counter = 0;

      $row.find('td').map(function () {
        var $this = $(this);

        if (!$this.hasClass('actions')) {
          //   _self.rowSetActionsDefault($row);
          //   return $('td:last', $row).html();
          // } else {
          values[columnsOrder[counter++]] = $.trim($this.find('input').val());
        }
      });

      this.datatable.row($row.get(0)).data(values);

      var rowIndex,
        ajaxData,
        _self = this,
        dataArray = this.datatable.data().toArray();

      if ($row.hasClass('adding')) {
        rowIndex = dataArray.length - 1;
        ajaxData = dataArray[rowIndex];
        delete ajaxData.id;

        this.$addButton.removeAttr('disabled');
        $row.removeClass('adding');
      } else {
        for (var k = 0; k < dataArray.length; k++) {
          if(parseInt(dataArray[k].id,10) === $row.data("item-id")){
            rowIndex = k;
            ajaxData = dataArray[rowIndex];
            break;
          }
        }
      }

      $actions = $row.find('td.actions');
      if ($actions.get(0)) {
        this.rowSetActionsDefault($row);
      }


      $.ajax({
        url: url,
        type: 'PATCH',
        contentType: "application/json",
        accepts: {
          mycustomtype: "application/json"
        },
        data: JSON.stringify(Object.assign({}, ajaxData)),
        success: function (response, textStatus, jqXhr) {
          _self.datatable.ajax.reload(function () {
            $actions = $row.find('td.actions');
            if ($actions.get(0)) {
              _self.rowSetActionsDefault($row);
            }

            _self.datatable.draw();
          });
        },
        error: function (jqXHR, textStatus, errorThrown) {
          alert("Error: " + textStatus + " / " + errorThrown);
        },
        complete: function () {
        }
      });
    },

    rowRemove: function ($row) {
      if ($row.hasClass('adding')) {
        this.$addButton.removeAttr('disabled');
      }

      this.datatable.row($row.get(0)).remove().draw();
    },

    rowSetActionsEditing: function ($row) {
      $row.find('.on-editing').removeClass('hidden');
      $row.find('.on-default').addClass('hidden');
    },

    rowSetActionsDefault: function ($row) {
      $row.find('.on-editing').addClass('hidden');
      $row.find('.on-default').removeClass('hidden');
    }

  };

  $(function () {
    EditableTable.initialize();
  });

}).apply(this, [jQuery]);
