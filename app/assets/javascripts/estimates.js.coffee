# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ -> 
	$body = $('body.estimates')
	$lineRows = $('table.line_items tr.edit', $body)
	$lineItemInput = $('td.editable input', $lineRows)
	$lineCk = $('td.line_ck input[type="checkbox"]', $lineRows)
	$lineLinks = $('td.line_links a', $lineRows)
	$estimateTotal = $('table.line_items tr.total_line td.total_price', $body)
	$client = $('#estimate_client_id', $body)

	$('table.line_items tr.add_lines td a', $body).addClass 'small radius blue button'
	
	lineItemEffects $lineItemInput
					
	$lineItemInput.live "blur", ->
		updateEstimateTotals $(this).parents("tr"), $estimateTotal
	
	$lineCk.live "click", ->
		updateEstimateTotals $(this).parents("tr"), $estimateTotal
	
	$lineLinks.live "click", ->
		t = setTimeout( (-> updateEstimateTotals($(this).parents("tr"), $estimateTotal)), 500 )
	
	#$client.change ->
	#	getNewClient $client

lineItemEffects = (lineItemInput) ->	
	lineItemInput.live "mouseenter", ->
		$(this).parent().addClass 'hover'
	lineItemInput.live "mouseleave", ->
		$(this).parent().removeClass 'hover'
		
	lineItemInput.live "focus", ->
		$(this).parent().addClass 'focus'
	lineItemInput.live "blur", ->
		$(this).parent().removeClass 'focus'
		
		
updateEstimateTotals = (lineRow, estimateTotal) ->
	newLineTotal = 0
	if $('td.line_ck input[type="checkbox"]', lineRow).is ":checked"
		newLineTotal = $('td.line_qty input', lineRow).val()*$('td.line_u_price input', lineRow).val()
	newLineTotal = formatNumber newLineTotal,2,',','.','','','-',''
	$('td.line_t_price', lineRow).html newLineTotal
		
	lineUnitPrice = $('td.line_u_price input', lineRow).val()
	if lineUnitPrice != ""
		if !isNaN(lineUnitPrice)
			lineUnitPrice = formatNumber lineUnitPrice,2,'','.','','','-',''
			$('td.line_u_price input', lineRow).val(lineUnitPrice)
	
	newEstimateTotal = 0
	$('td.line_t_price:visible').each ->
		number = Number $(this).html().replace(/[^0-9\.]+/g,"")
		newEstimateTotal += number
	newEstimateTotal = formatNumber newEstimateTotal,2,',','.','$','','-',''
	estimateTotal.html newEstimateTotal


getNewClient = (client) ->
	# get new value and store in selected_client
	selected_client = client.val()
	# re-render partial where :locals => {@client = selected_client}
	$('p.address').html("<%= escape_javascript(render :partial => 'clients/client_address', :locals => {:selected_client => @client }) %>")	
	