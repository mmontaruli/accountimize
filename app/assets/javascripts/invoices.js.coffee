$ ->
	$invoiceBody = $("body.invoices")
	$invoiceLineRows = $('table.line_items tr.line_item', $invoiceBody)
	$invoiceLineItemInput = $('td input', $invoiceLineRows)
	$invoiceClient = $('#invoice_client_id', $invoiceBody)
	$invoiceTotal = $('tr.total_line td.total_price', $invoiceBody)
	$invoiceLineDelete = $("td.line_links .delete_link a", $invoiceLineRows)

	invoiceLineItemEffects $invoiceLineItemInput

	$invoiceClient.change ->
		invoiceGetNewClient $invoiceClient

	$invoiceLineItemInput.live "blur", ->
		updateInvoiceTotals $(this).parents("tr.line_item"), $invoiceTotal

	$invoiceLineDelete.live "click", ->
		subtractInvoiceLineTotal $(this).parents("tr.line_item"), $invoiceTotal

invoiceLineItemEffects = (lineItemInput) ->
	# rollover and active effects for edit view
	# can this be done with css/scss?
	lineItemInput.live "mouseenter", ->
		$(this).parent().addClass 'hover'
	lineItemInput.live "mouseleave", ->
		$(this).parent().removeClass 'hover'

	lineItemInput.live "focus", ->
		$(this).parent().addClass 'focus'
	lineItemInput.live "blur", ->
		$(this).parent().removeClass 'focus'

updateInvoiceTotals = (lineRow, invoiceTotal) ->
	lineQty = lineRow.find("td.line_qty input").val()
	lineUnitPrice = lineRow.find("td.line_u_price input").val()
	lineTotalPrice = lineRow.find("td.line_t_price")

	if isNaN(lineQty)
		lineQty = 0
	if isNaN(lineUnitPrice)
		lineUnitPrice = 0

	newLineTotal = 0
	newLineTotal = lineQty * lineUnitPrice
	newLineTotal = formatNumber newLineTotal,2,',','.','','','-',''
	lineTotalPrice.html(newLineTotal)

	unless lineUnitPrice is ""
		unless isNaN(lineUnitPrice)
			lineUnitPrice = formatNumber lineUnitPrice,2,'','.','','','-',''
			$('td.line_u_price input', lineRow).val(lineUnitPrice)

	newInvoiceTotal = 0
	$("tr.line_item td.line_t_price:visible").each ->
		negative = false
		if $(this).html().slice(0,1) == "-"
			negative = true
		number = Number $(this).html().replace(/[^0-9\.]+/g,"")
		if negative == true
			number = 0 - number
		newInvoiceTotal += number
	newInvoiceTotal = formatNumber newInvoiceTotal,2,',','.','$','','-',''
	invoiceTotal.html(newInvoiceTotal)

subtractInvoiceLineTotal = (lineRow, invoiceTotal) ->

	newInvoiceTotal = invoiceTotal.html()
	newInvoiceTotal = newInvoiceTotal.slice(1)
	newInvoiceTotal = newInvoiceTotal.replace(/,/, '')
	newInvoiceTotal = Number newInvoiceTotal

	lineTotalPrice = lineRow.find("td.line_t_price").html()
	lineTotalPrice = lineTotalPrice.replace(/,/, '')
	lineTotalPrice = Number lineTotalPrice

	newInvoiceTotal = newInvoiceTotal - lineTotalPrice
	newInvoiceTotal = formatNumber newInvoiceTotal,2,',','.','$','','-',''
	invoiceTotal.html(newInvoiceTotal)

invoiceGetNewClient = (client) ->
	# change client address based on selected client in dropdown
	selected_client = client.val()
	unless selected_client is ''
		urlbase = client.attr('data-url-base')
		url = urlbase+'/'+selected_client+'/client_address'
		$('p.address').load url
	else
		$('p.address').empty()
