$ ->
	$tableTotal = $('.table_total strong, .total_price strong')
	$deleteLink = $("table.has_total td.line_links .delete_link a, table.line_items td.line_links .delete_link a")
	$tableHasTotal = $("table.has_total")
	$tableLineItems = $("table.line_items")
	$invoiceLines = $('table.has_total tr')
	$editableLines = $('table.line_items tr td input, table.line_items tr td textarea')
	$client_select = $('.client_select')
	deleteLink = 'td.line_links .delete_link a'
	lineItemInput = "tr td input"

	$tableHasTotal.on "click", deleteLink, ->
		subtractFromTotal $(this).parents('tr'), $tableTotal

	lineItemEffects $tableLineItems

	$client_select.change ->
		getNewClient $client_select

	$tableHasTotal.on "blur", lineItemInput, ->
		updateLineTotals $(this).parents("tr.line"), $tableTotal

	if bodyClassDisableEnter($('body')) and formIDDisableEnter($('form').attr('id'))
		$("form").bind "keydown", (e) ->
			if e.keyCode is 13
				return false

lineItemEffects = (table) ->
	# rollover and active effects for edit view
	editableLines = 'tr td input:enabled, tr td textarea:enabled'

	table.on "mouseenter", editableLines, ->
		$(this).parent().addClass('hover')
	table.on "mouseleave", editableLines, ->
		$(this).parent().removeClass('hover')
	table.on "focus", editableLines, ->
		$(this).parent().addClass('focus')
	table.on "blur", editableLines, ->
		$(this).parent().removeClass('focus')

getNewClient = (client) ->
	# change client address based on selected client in dropdown
	selected_client = client.val()
	unless selected_client is ''
		urlbase = client.attr('data-url-base')
		url = urlbase+'/'+selected_client+'/client_address'

		contactUrl = urlbase+'/'+selected_client+'/user_select'

		$('p.address').load url
		$('.contact').load contactUrl
	else
		$('p.address').empty()
		$('.contact').empty()


subtractFromTotal = (lineRow, total) ->
	# subtract line item total when it is deleted
	if lineRow.hasClass 'percent_type'
		type = 'percent'
	else
		type = 'currency'

	newTotal = total.html()
	newTotal = Number(newTotal.replace(/[^0-9.]/g, ''))

	lineTotal = lineRow.find(".line_total, .line_t_price")
	unless lineTotal.html() is ''
		lineTotal = lineTotal.html()
	else
		lineTotal = lineTotal.val()

	lineTotal = Number(lineTotal.replace(/[^0-9.]/g, ''))

	newTotal -= lineTotal
	if type is "currency"
		newTotal = formatNumber newTotal,2,',','.','$','','-',''
	else if type is "percent"
		newTotal += " %"

	total.html(newTotal)


bodyClassDisableEnter = (body) ->
# function to test body class
	if body.hasClass("estimates") or body.hasClass("invoices")
		return true
	else
		return false

formIDDisableEnter = (formID) ->
# function to test form class
	if formID is "new_invoice" or formID is "new_estimate"
		return true
	else if formID.indexOf("edit_estimate_") is 0 or formID.indexOf("edit_invoice_") is 0
		return true
	else
		return false

