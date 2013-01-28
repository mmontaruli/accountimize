var fixHelperModified = function(e, tr) {
    var $originals = tr.children();
    var $helper = tr.clone();
    $helper.children().each(function(index) {
        $(this).width($originals.eq(index).width());
    });
    return $helper;
},
    updateIndex = function(e, ui) {
        $('td.line_ck input.line_item_position', ui.item.parent()).each(function (i) {
            $(this).val(i + 1);
        });
    },

    allowFormSelect = function() {
        $(".estimate-second-step table.line_items tbody.selected, .estimate-second-step table.line_items tbody.deselected").find("input, select, textarea").bind('mousedown.ui-disableSelection selectstart.ui-disableSelection', function(e) {
            e.stopImmediatePropagation();
        });
    };

