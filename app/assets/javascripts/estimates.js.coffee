# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ -> 
	body = $('body.estimates')
	lineRows = $('table.line_items tr.edit', body)
	lineItemInput = $('td.editable input', lineRows)
	lineCk = $('td.line_ck input[type="checkbox"]', lineRows)
	estimateTotal = $('table.line_items tr.total_line td.total_price', body)
	
	lineItemEffects lineItemInput
		
	lineItemInput.blur ->
		updateEstimateTotals $(this).parents("tr"), estimateTotal
		
	lineCk.click ->
		updateEstimateTotals $(this).parents("tr"), estimateTotal

			
lineItemEffects = (lineItemInput) ->
	lineItemInput.hover ->
		$(this).parent().addClass 'hover'
	, ->
		$(this).parent().removeClass 'hover'
	
	lineItemInput.focus ->
		$(this).parent().addClass 'focus'
	lineItemInput.blur ->
		$(this).parent().removeClass 'focus'
		
		
updateEstimateTotals = (lineRow, estimateTotal) ->
	newLineTotal = 0
	if $('td.line_ck input[type="checkbox"]', lineRow).is ":checked"
		newLineTotal = $('td.line_qty input', lineRow).val()*$('td.line_u_price input', lineRow).val()
	newLineTotal = formatNumber newLineTotal,2,',','.','','','-',''
	$('td.line_t_price', lineRow).html newLineTotal
		
	newEstimateTotal = 0
	$('td.line_t_price').each ->
		number = Number $(this).html().replace(/[^0-9\.]+/g,"")
		newEstimateTotal += number
	newEstimateTotal = formatNumber newEstimateTotal,2,',','.','$','','-',''
	estimateTotal.html newEstimateTotal

