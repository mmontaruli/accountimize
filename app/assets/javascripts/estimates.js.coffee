$ ->
	$body = $('body.estimates')
	$tableLineItems = $('table.line_items', $body)
	$estimateTotal = $('table.line_items tr.total_line td.total_price strong', $body)
	lineCk = 'tr td.line_ck input[type="checkbox"]'
	toggle = 'tr td.line_price_type select'
	lineVal = 'tr input.line_value'
	accept = 'tr td .thumbs-up input[type=checkbox]'


	negotiateCheckAndSelect lineCk

	$tableLineItems.on "click", lineCk, ->
		updateLineTotals $(this).parents("tr"), $estimateTotal

	$tableLineItems.on "change", toggle, ->
		fixedHourlyToggle $(this).parents("tr"), $(this)
		updateLineTotals $(this).parents("tr"), $estimateTotal

	$tableLineItems.on "blur", lineVal, ->
		updateFixedAndHourlyValues $(this)

	$tableLineItems.on "click", accept, ->
		acceptLine $(this)
		updateLineTotals $(this).parents("tr").prevAll("tr.line_item").eq(0), $estimateTotal


negotiateCheckAndSelect = (lineCk) ->
	negotiateCks = 'table.line_items ' + lineCk

	$(negotiateCks).each ->
		unless $(this).is(':checked')
			$(this).parents("tr.line_item.edit_false").addClass 'removed'

	$(document).on "click", negotiateCks, ->
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

acceptLine = (accept) ->
	line_item = accept.parents "tr.line_item"
	thumbs_down = line_item.find("td.line_links a.thumbs-down")
	estimate_line = line_item

	if line_item.length == 0
		line_item_has_negotiate_lines = true
		negotiate_line = accept.parents "tr.negotiate_line"
		estimate_line = negotiate_line
		line_item = negotiate_line.prevAll("tr.line_item").eq(0)
		thumbs_down = negotiate_line.find(".thumbs-down")

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
		# removes any incorrect classes and then highlights line in green
		estimate_line.removeClass "accepted_false"
		estimate_line.addClass "accepted_true"

		# hide thumbs down
		thumbs_down.hide()

		# replace price_type dropdown with text value
		line.price_type.select.hide()
		line.price_type.accept.show().html(line.price_type.select.val())

		# enable line_item if not enabled already
		line.is_enabled.attr('checked','checked')
		line_item.removeClass('removed')

		if line_item_has_negotiate_lines
			# change negotiate dropdown to value
			negotiate.price_type.select.hide()
			negotiate.price_type.accept.show().html(negotiate.price_type.select.val())

			# change line_item values to negotiate values
			line.qty.htm.html(negotiate.qty.val())
			line.qty.valu.val(negotiate.qty.val())
			line.price.htm.html(negotiate.price.val())
			line.price.valu.val(negotiate.price.val())

			# slide up other negotiate lines on accept
			negotiate.other_lines.slideUp();

	else
		# removes any incorrect classes and sets class to not accepted
		estimate_line.removeClass "accepted_true"
		estimate_line.addClass "accepted_false"

		# show thumbs down
		thumbs_down.css('display', '')

		# changes price_type text value back to dropdown
		line.price_type.accept.hide()
		line.price_type.select.show()

		if line_item_has_negotiate_lines
			# change negotiate value to dropdown
			negotiate.price_type.accept.hide()
			negotiate.price_type.select.show()

			# change line_item values back to original values
			fixedHourlyToggle(line_item, line.price_type.select)

			# slide down other negotiate lines on accept uncheck
			negotiate.other_lines.slideDown()
