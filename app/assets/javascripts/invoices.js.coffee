$ ->
	$body = $("body.invoices")
	$client = $('#invoice_client_id', $body)

	$client.change ->
		getNewClient $client

getNewClient = (client) ->
	# change client address based on selected client in dropdown
	selected_client = client.val()
	unless selected_client is ''
		urlbase = client.attr('data-url-base')
		url = urlbase+'/'+selected_client+'/client_address'
		$('p.address').load url
	else
		$('p.address').empty()
