updateLineTotals = function(lineRow, total) {
	var estimateLineItem, lineQty, lineUnitPrice, lineTotalPrice, newLineTotal;
	estimateLineItem = lineRow.filter('.line_item');
	lineQty = lineRow.find("td.line_qty input.line_qty").val();
	lineUnitPrice = lineRow.find("td.line_u_price input.line_unit_price").val();
	lineTotalPrice = lineRow.find("td.line_t_price");

	if (isNaN(lineQty)) {
		lineQty = 0;
	}
	if (isNaN(lineUnitPrice)) {
		lineUnitPrice = 0;
	}

	newLineTotal = 0;
	if ($('body').hasClass('estimates') && $('table.line_items').hasClass('estimate-edit')) {
		if ($('td.line_ck input[type="checkbox"]', estimateLineItem).is(":checked") || lineRow.hasClass("negotiate_line")) {
			newLineTotal = lineQty * lineUnitPrice;
		}
	} else {
		newLineTotal = lineQty * lineUnitPrice;
	}

	newLineTotal = formatNumber(newLineTotal,2,',','.','','','-','');
	lineTotalPrice.html(newLineTotal);

	if (lineUnitPrice !== "") {
		if (!isNaN(lineUnitPrice)) {
			lineUnitPrice = formatNumber(lineUnitPrice,2,'','.','','','-','');
			$('td.line_u_price input.line_unit_price', lineRow).val(lineUnitPrice);
		}
	}

	updateInvoiceTotals(total);
}

updateInvoiceTotals = function(total) {
	var negative, newInvoiceTotal, number;
	newInvoiceTotal = 0;
	$("tr.line_item td.line_t_price:visible, .line_total:visible").each(function(){
		if ($(this).html() !== '') {
			negative = false;
			if ($(this).html().slice(0,1) == "-") {
				negative = true;
			}
			number = Number($(this).html().replace(/[^0-9\.]+/g,""));
		} else {
			number = Number($(this).val().replace(/[^0-9\.]+/g,""));
		}
		if (negative == true) {
			number = 0 - number;
		}
		newInvoiceTotal += number;
	});
	if ($("tr.line_item td.line_t_price:visible, .line_total").parents('tr').hasClass('percent_type')) {
		newInvoiceTotal = formatNumber(newInvoiceTotal,0,',','','','','-','');
		newInvoiceTotal += " %";
	} else {
		newInvoiceTotal = formatNumber(newInvoiceTotal,2,',','.','$','','-','');
	}

	total.html(newInvoiceTotal);
}
