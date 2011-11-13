# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ -> 
	# Can these variables be called into functions below? If not, delete
	body = $('body.estimates')
	lineRows = $('table.line_items tr.edit', body)
	lineItemInput = $('td.editable input', lineRows)
	lineCk = $('td.line_ck input[type="checkbox"]', lineRows)
	lineQty = $('td.line_qty input', lineRows)
	lineUnitPrice = $('td.line_u_price input', lineRows)
	lineTotal = $('td.line_t_price', lineRows)
	estimateTotal = $('table.line_items tr.total_line td.total_price')
	
	lineItemEffects(lineItemInput)
	
	lineItemInput.blur ->
		updateEstimateTotals($(this).parents("tr"))
		
	lineCk.click ->
		updateEstimateTotals($(this).parents("tr"))
		
	# Same function above is called twice. Can this be condensed?		
		
lineItemEffects = (lineItemInput) ->
	lineItemInput.hover ->
		$(this).parent().addClass 'hover'
	, ->
		$(this).parent().removeClass 'hover'
	
	lineItemInput.focus ->
		$(this).parent().addClass 'focus'
	lineItemInput.blur ->
		$(this).parent().removeClass 'focus'
		
		
updateEstimateTotals = (lineRow) ->
	newLineTotal = 0
	if $('td.line_ck input[type="checkbox"]', lineRow).is(":checked")
		newLineTotal = $('td.line_qty input', lineRow).val()*$('td.line_u_price input', lineRow).val()
	$('td.line_t_price', lineRow).html newLineTotal
		
	newEstimateTotal = 0
	$('td.line_t_price').each ->
		number = Number($(this).html().replace(/[^0-9\.]+/g,""));
		newEstimateTotal += number
	$('table.line_items tr.total_line td.total_price').html newEstimateTotal
	
	# Numbers need to be formatted as dollars
	