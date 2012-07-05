$ ->
	$tableTotal = $('.table_total strong, .total_price strong')
	$deleteLink = $("table.has_total td.line_links .delete_link a, table.line_items td.line_links .delete_link a")
	$invoiceLines = $('table.has_total tr')
	$editableLines = $('table.line_items tr td input, table.line_items tr td textarea')
	$client_select = $('.client_select')

	$deleteLink.live "click", ->
		subtractFromTotal $(this).parents('tr'), $tableTotal

	lineItemEffects $editableLines

	$client_select.change ->
		getNewClient $client_select

	$invoiceLines.find("td input").live "blur", ->
		updateLineTotals $(this).parents("tr"), $tableTotal


lineItemEffects = (lineItemInput) ->
	# rollover and active effects for edit view
	lineItemInput.live "mouseenter", ->
		$(this).parent().addClass('hover')
	lineItemInput.live "mouseleave", ->
		$(this).parent().removeClass('hover')
	lineItemInput.live "focus", ->
		$(this).parent().addClass('focus')
	lineItemInput.live "blur", ->
		$(this).parent().removeClass('focus')

getNewClient = (client) ->
	# change client address based on selected client in dropdown
	selected_client = client.val()
	unless selected_client is ''
		urlbase = client.attr('data-url-base')
		url = urlbase+'/'+selected_client+'/client_address'
		$('p.address').load url
	else
		$('p.address').empty()


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

