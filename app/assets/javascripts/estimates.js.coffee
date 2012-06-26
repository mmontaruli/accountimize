$ ->
	$body = $('body.estimates')

	#this is only called in other variables, but could very possibly be replaced with $estimateLines
	$lineRows = $('table.line_items tr.line_item', $body)

	#only called once, can we just filter/find this from another variable?
	$lineItemInput = $('td input', $lineRows)

	$negotiateItemInput = $('table.line_items tr.negotiate_line td input, table.line_items tr.negotiate_line td textarea');
	$estimateLines = $('table.line_items tr', $body)
	#added $body to $stimateLines later, don't seem to find any trouble with this

	#$lineCk and $lineLinks only called once, can we just filter/find this from another variable?
	$lineCk = $('td.line_ck input[type="checkbox"]', $lineRows)
	$lineLinks = $('td.line_links a', $lineRows)

	$estimateTotal = $('table.line_items tr.total_line td.total_price', $body)

	#only called once, can we just filter/find this from another variable?
	$client = $('#estimate_client_id', $body)

	$negotiateCks = $('table.line_items tr.line_item.edit_false td.line_ck input[type="checkbox"]', $body)

	#only called once, can we just filter/find this from another variable?
	$toggle = $('td.line_price_type select', $estimateLines)

	#$line_price and $line_qty don't seem to be used...experiment with not using
	$line_price = $('td.line_u_price input.line_unit_price')
	$line_qty = $('td.line_qty input.line_qty')

	#only called once, can we just filter/find this from another variable?
	$lineVal = $('input.line_value', $estimateLines)



	negotiateCheckAndSelect $negotiateCks

	lineItemEffects $lineItemInput

	lineItemEffects $negotiateItemInput

	$estimateLines.find('td input').live "blur", ->
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

	$estimateLines.find("td.blank.accept input[type=checkbox]").live "click", ->
		acceptNegotiateLine $(this)
		updateEstimateTotals $(this).parents("tr").prevAll("tr.line_item").eq(0), $estimateTotal

	$estimateLines.find("td.line_links .action-button li.accept_line input[type=checkbox]").live "click", ->
		acceptLineItem $(this)

	$estimateLines.find("td.line_links .action-button a.action-drop-down").live "click", ->
		actionButton = $(this)
		actionButton.addClass("click")
		actionButton.next().show()
		$('body').live "click", ->
			actionButton.next().hide()
			actionButton.removeClass("click")
		false

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

updateEstimateTotals = (estimateRow, estimateTotal) ->
	# check for negotiate or edit view then total line and estimate totals as appropriate
	newLineTotal = 0

	lineRow = estimateRow.filter('.line_item')
	lineQty = $('td.line_qty input.line_qty', estimateRow).val()
	lineUnitPrice = $('td.line_u_price input.line_unit_price', estimateRow).val()

	if $('td.line_ck input[type="checkbox"]', lineRow).is(":checked") or estimateRow.hasClass "negotiate_line"
		newLineTotal = lineQty*lineUnitPrice
	newLineTotal = formatNumber newLineTotal,2,',','.','','','-',''
	$('td.line_t_price', estimateRow).html newLineTotal

	unless lineUnitPrice is ""
		unless isNaN(lineUnitPrice)
			lineUnitPrice = formatNumber lineUnitPrice,2,'','.','','','-',''
			$('td.line_u_price input.line_unit_price', estimateRow).val(lineUnitPrice)

	newEstimateTotal = 0
	$('tr.line_item td.line_t_price:visible').each ->
		negative = false
		if $(this).html().slice(0,1) == "-"
			negative = true
		number = Number $(this).html().replace(/[^0-9\.]+/g,"")
		if negative == true
			number = 0 - number
		newEstimateTotal += number
	newEstimateTotal = formatNumber newEstimateTotal,2,',','.','$','','-',''
	estimateTotal.html newEstimateTotal


getNewClient = (client) ->
	# change client address based on selected client in dropdown
	selected_client = client.val()
	unless selected_client is ''
		urlbase = client.attr('data-url-base')
		url = urlbase+'/'+selected_client+'/client_address'
		$('p.address').load url
	else
		$('p.address').empty()

negotiateCheckAndSelect = (negotiateCks) ->
	# select line items in negotiate view
	negotiateCks.each ->
		unless $(this).is(':checked')
			$(this).parents("tr.line_item.edit_false").addClass 'removed'

	negotiateCks.live "click", ->
		if $(this).is(':checked')
			$(this).parents("tr.line_item.edit_false").removeClass 'removed'
		else
			$(this).parents("tr.line_item.edit_false").addClass 'removed'

fixedHourlyToggle = (lineRow, toggle) ->
	# to update line_item values to hourly or fixed (on toggle change)
	fixedQty = $('td.line_qty input.fixed_qty', lineRow)
	hoursQty = $('td.line_qty input.hours_qty', lineRow)
	fixedRate = $('td.line_u_price input.fixed_rate', lineRow)
	hoursRate = $('td.line_u_price input.hours_rate', lineRow)

	lineQty = $('td.line_qty input.line_qty', lineRow)
	lineUnitPrice = $('td.line_u_price input.line_unit_price', lineRow)

	if toggle.val() is 'fixed'
		lineQty.val(fixedQty.val())
		lineUnitPrice.val(fixedRate.val())
	if toggle.val() is 'hourly'
		lineQty.val(hoursQty.val())
		lineUnitPrice.val(hoursRate.val())

	if lineRow.hasClass('edit_false') or lineRow.hasClass('submitted')
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

	if toggle.val() is "fixed"
		changeVal = changeType.fixed
	if toggle.val() is "hourly"
		changeVal = changeType.hourly

	changeVal.val(changeType.line.val())

acceptNegotiateLine = (accept) ->
	# Changes color of negotiate_line and hides negotiate button if accepted
	# and changes line_item values according to accepted negotiate line
	negotiate_line = accept.parents "tr.negotiate_line"
	line_item = negotiate_line.prevAll("tr.line_item").eq(0)
	action_button = line_item.find("td.line_links .action-button")
	negotiate_button = line_item.find("td.line_links .add_negotiation_line a")

	negotiate =
		price_type:
			select: negotiate_line.find("td.line_price_type select")
			accept: negotiate_line.find("td.line_price_type .accept")
		qty: negotiate_line.find("td.line_qty input.line_qty")
		price: negotiate_line.find("td.line_u_price input.line_unit_price")
		other_lines: negotiate_line.prevUntil("tr.line_item", "tr.negotiate_line")

	line =
		price_type:
			select: line_item.find("td.line_price_type select")
			accept: line_item.find("td.line_price_type .accept")
		qty:
			valu: line_item.find("td.line_qty input.line_qty")
			htm: line_item.find("td.line_qty .line_qty_val")
		price:
			valu: line_item.find("td.line_u_price input.line_unit_price")
			htm: line_item.find("td.line_u_price .line_unit_price_val")
		is_accepted: line_item.find("td.line_links input.line_is_accepted")
		is_enabled: line_item.find('td.line_ck input[type="checkbox"]')


	if accept.is ':checked'

		# highlight negotiate line in green
		negotiate_line.addClass "accepted"

		# hide action button
		action_button.hide()

		# change price_type dropdown to text value
		line.price_type.select.hide()
		line.price_type.accept.show().html(negotiate.price_type.select.val())
		negotiate.price_type.select.hide()
		negotiate.price_type.accept.show().html(negotiate.price_type.select.val())

		# change line_item values to negotiate values
		line.qty.htm.html(negotiate.qty.val())
		line.qty.valu.val(negotiate.qty.val())
		line.price.htm.html(negotiate.price.val())
		line.price.valu.val(negotiate.price.val())

		# slide up other negotiate lines on accept
		negotiate.other_lines.slideUp();

		# set line_item to accepted status
		line.is_accepted.val(true)

		# enables accepted line item if it was previously unchecked
		line.is_enabled.attr('checked','checked')
		line_item.removeClass('removed')
	else

		#un-highlight negotiate line
		negotiate_line.removeClass "accepted"

		# show action button
		action_button.show()

		# change price_type text value back to dropdown
		line.price_type.accept.hide()
		line.price_type.select.show()
		negotiate.price_type.accept.hide()
		negotiate.price_type.select.show()

		# change line_item values back to original values
		fixedHourlyToggle(line_item, line.price_type.select)

		# slide down other negotiate lines on accept uncheck
		negotiate.other_lines.slideDown()

		# set line_item to not accepted status
		line.is_accepted.val(false)

acceptLineItem = (accept) ->
	line_item = accept.parents "tr.line_item"
	negotiate_button = line_item.find("td.line_links .add_negotiation_line a")

	line =
		price_type:
			select: line_item.find("td.line_price_type select")
			accept: line_item.find("td.line_price_type .accept")
		is_enabled: line_item.find('td.line_ck input[type="checkbox"]')

	if accept.is ':checked'

		# removes any incorrect classes and then highlights line in green
		line_item.removeClass "accepted_false"
		line_item.addClass "accepted_true"

		# disable negotiate menu item
		negotiate_button.hide()
		negotiate_button.next().html("Negotiate").show()

		# replace price_type dropdown with text value
		line.price_type.select.hide()
		line.price_type.accept.show().html(line.price_type.select.val())

		# enable line_item if not enabled already
		line.is_enabled.attr('checked','checked')
		line_item.removeClass('removed')
	else

		# removes any incorrect classes and sets class to not accepted
		line_item.removeClass "accepted_true"
		line_item.addClass "accepted_false"

		# enables negotiate button
		negotiate_button.next().hide()
		negotiate_button.show()

		# changes price_type text value back to dropdown
		line.price_type.accept.hide()
		line.price_type.select.show()

