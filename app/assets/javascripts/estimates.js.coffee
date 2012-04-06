# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ -> 
	$body = $('body.estimates')
	#$lineRows = $('table.line_items tr.js_edit', $body)
	$lineRows = $('table.line_items tr.line_item', $body)
	#$lineItemInput = $('td.editable input', $lineRows)
	$lineItemInput = $('td input', $lineRows)
	$lineCk = $('td.line_ck input[type="checkbox"]', $lineRows)
	$lineLinks = $('td.line_links a', $lineRows)
	$estimateTotal = $('table.line_items tr.total_line td.total_price', $body)
	$client = $('#estimate_client_id', $body)
	#$negotiateCks = $('table.line_items tr.negotiate td.line_ck input[type="checkbox"]', $body)
	$negotiateCks = $('table.line_items tr.line_item.edit_false td.line_ck input[type="checkbox"]', $body)
	$toggle = $('td.line_price_type select', $lineRows)
	$line_price = $('td.line_u_price input.line_unit_price')
	$line_qty = $('td.line_qty input.line_qty')
	$lineVal = $('input.line_value', $lineRows)
	
	
	$('table.line_items tr.add_lines td a', $body).addClass 'small radius blue button'
	
	negotiateCheckAndSelect $negotiateCks
	
	lineItemEffects $lineItemInput
	
	$lineItemInput.live "blur", ->
		updateEstimateTotals $(this).parents("tr"), $estimateTotal
	
	$lineCk.live "click", ->
		updateEstimateTotals $(this).parents("tr"), $estimateTotal
	
	$lineLinks.live "click", ->
		t = setTimeout( (-> updateEstimateTotals($(this).parents("tr"), $estimateTotal)), 500 )
	
	$client.change ->
		getNewClient $client
		
	$toggle.live "change", ->
		fixedHourlyToggle $(this).parents("tr"), $(this)
		updateEstimateTotals $(this).parents("tr"), $estimateTotal
	
	$lineVal.live "blur", ->
		updateFixedAndHourlyValues $(this)

lineItemEffects = (lineItemInput) ->
	# rollover and active effects for edit view	
	lineItemInput.live "mouseenter", ->
		$(this).parent().addClass 'hover'
	lineItemInput.live "mouseleave", ->
		$(this).parent().removeClass 'hover'
		
	lineItemInput.live "focus", ->
		$(this).parent().addClass 'focus'
	lineItemInput.live "blur", ->
		$(this).parent().removeClass 'focus'
		
		
updateEstimateTotals = (lineRow, estimateTotal) ->
	# check for negotiate or edit view then total line and estimate totals as appropriate
	newLineTotal = 0
	
	lineQty = $('td.line_qty input.line_qty', lineRow).val()
	lineUnitPrice = $('td.line_u_price input.line_unit_price', lineRow).val()
	
	if $('td.line_ck input[type="checkbox"]', lineRow).is ":checked"
		newLineTotal = lineQty*lineUnitPrice
	newLineTotal = formatNumber newLineTotal,2,',','.','','','-',''
	$('td.line_t_price', lineRow).html newLineTotal
		
	if lineUnitPrice != ""
		if !isNaN(lineUnitPrice)
			lineUnitPrice = formatNumber lineUnitPrice,2,'','.','','','-',''
			$('td.line_u_price input.line_unit_price', lineRow).val(lineUnitPrice)
	
	newEstimateTotal = 0
	$('td.line_t_price:visible').each ->
		number = Number $(this).html().replace(/[^0-9\.]+/g,"")
		newEstimateTotal += number
	newEstimateTotal = formatNumber newEstimateTotal,2,',','.','$','','-',''
	estimateTotal.html newEstimateTotal


getNewClient = (client) ->
	# change client address based on selected client in dropdown
	selected_client = client.val()
	if selected_client != ''
		urlbase = client.attr('data-url-base')
		url = urlbase+'/'+selected_client+'/client_address'
		$('p.address').load url
	else
		$('p.address').empty()
		
negotiateCheckAndSelect = (negotiateCks) ->
	# select line items in negotiate view
	negotiateCks.each ->
		if !$(this).is(':checked')
			#$(this).parents("tr.negotiate").addClass 'removed'
			$(this).parents("tr.line_item.edit_false").addClass 'removed'
			
	negotiateCks.live "click", ->
		if $(this).is(':checked')
			#$(this).parents("tr.negotiate").removeClass 'removed'
			$(this).parents("tr.line_item.edit_false").removeClass 'removed'
		else if !$(this).is(':checked')
			#$(this).parents("tr.negotiate").addClass 'removed'
			$(this).parents("tr.line_item.edit_false").addClass 'removed'
	
fixedHourlyToggle = (lineRow, toggle) ->
	# to update line_item values to hourly or fixed (on toggle change)
	fixedQty = $('td.line_qty input.fixed_qty', lineRow)
	hoursQty = $('td.line_qty input.hours_qty', lineRow)
	fixedRate = $('td.line_u_price input.fixed_rate', lineRow)
	hoursRate = $('td.line_u_price input.hours_rate', lineRow)
	
	lineQty = $('td.line_qty input.line_qty', lineRow)
	lineUnitPrice = $('td.line_u_price input.line_unit_price', lineRow)
	
	if toggle.val() == 'fixed'
		lineQty.val(fixedQty.val())
		lineUnitPrice.val(fixedRate.val())
	if toggle.val() == 'hourly'
		lineQty.val(hoursQty.val())
		lineUnitPrice.val(hoursRate.val())
		
	#if lineRow.hasClass('negotiate')
	if lineRow.hasClass('edit_false')
		$('td.line_qty .line_qty_val', lineRow).html(lineQty.val())
		$('td.line_u_price .line_unit_price_val', lineRow).html(lineUnitPrice.val())
	
	
updateFixedAndHourlyValues = (elem) ->
	# to update fixed and hourly values on line_value blur
	lineRow = elem.parents('tr')
	toggle = $('td.line_price_type select', lineRow)
	
	price = 
		line: $('td.line_u_price input.line_unit_price', lineRow)
		fixed: $('td.line_u_price input.fixed_rate', lineRow)
		hourly: $('td.line_u_price input.hours_rate', lineRow)
	
	qty = 
		line: $('td.line_qty input.line_qty', lineRow)
		fixed: $('td.line_qty input.fixed_qty', lineRow)
		hourly: $('td.line_qty input.hours_qty', lineRow)
		
	if elem.hasClass('line_qty')
		changeType = qty
	if elem.hasClass ('line_unit_price')
		changeType = price
	
	if toggle.val() == "fixed"
		changeVal = changeType.fixed
	if toggle.val() == "hourly"
		changeVal = changeType.hourly
		
	changeVal.val(changeType.line.val())