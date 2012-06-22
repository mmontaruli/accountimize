$ ->
	$body = $("body.invoices")
	$lineRows = $('table.line_items tr.line_item', $body)
	$lineItemInput = $('td input', $lineRows)
	$client = $('#invoice_client_id', $body)

	lineItemEffects $lineItemInput
	
	$client.change ->
		getNewClient $clientl

lineItemEffects = (lineItemInput) ->
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

getNewClient = (client) ->
	# change client address based on selected client in dropdown
	selected_client = client.val()
	unless selected_client is ''
		urlbase = client.attr('data-url-base')
		url = urlbase+'/'+selected_client+'/client_address'
		$('p.address').load url
	else
		$('p.address').empty()
