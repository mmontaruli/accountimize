$ ->
	$body = $('body.estimates')
	$tableLineItems = $('table.line_items', $body)
	$estimateTotal = $('table.line_items.second_step tr.total_line td.total_price strong', $body)
	$estimateFirstStep = $('.estimate-first-step', $body)
	$estimateSecondStep = $('.estimate-second-step', $body)
	selectLines = 'tr.line_item.select'
	lineCk = 'tr td.line_ck input[type="checkbox"]'
	toggle = 'tr td.line_price_type select'
	lineVal = 'tr input.line_value'
	accept = 'tr td .thumbs-up input[type=checkbox]'


	negotiateCheckAndSelect lineCk

	$tableLineItems.on "click", lineCk, ->
		secondScreenLineItemCheckAndSelect $(this).parents("tr")
		updateLineTotals $(this).parents("tr"), $estimateTotal

	$tableLineItems.on "change", toggle, ->
		fixedHourlyToggle $(this).parents("tr"), $(this)
		firstScreenSecondScreenToggle $(this).parents("tr")
		#updateLineTotals $(this).parents("tr"), $estimateTotal
		updateLineTotals $(this).parents("tr"), $(this).parents('table').find('tr.total_line td.total_price strong')

	$tableLineItems.on "blur", lineVal, ->
		updateFixedAndHourlyValues $(this)

	$tableLineItems.on "click", accept, ->
		acceptLine $(this)
		updateLineTotals $(this).parents("tr").prevAll("tr.line_item").eq(0), $estimateTotal

	$tableLineItems.on "click", selectLines, ->
		firstScreenLineItemClickAndSelect $(this)

	$body.on "click", '.estimate-first-step a.next', ->
		$estimateFirstStep.addClass("hidden")
		$estimateSecondStep.removeClass("hidden")
		$estimateSecondStep.find("table tr").each ->
			updateLineTotals $(this), $(this).parents('table').find('tr.total_line td.total_price strong')
		$(".actions").removeClass("hidden")
		false

	$body.on "click", '.actions a.back', ->
		$estimateSecondStep.addClass("hidden")
		$('.actions').addClass("hidden")
		$estimateFirstStep.find("table tr").each ->
			updateLineTotals $(this), $(this).parents('table').find('tr.total_line td.total_price strong')
		$estimateFirstStep.removeClass("hidden")
		false

	# $("body.estimates form").submit (event)->
	# 	event.preventDefault()
	# 	removeFirstSection($(this))

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

firstScreenLineItemClickAndSelect = (line_item) ->
	is_enabled = line_item.find 'input.is_enabled'
	line_item_num = line_item.attr("class").match(/line-id-[0-9]*/)[0]
	second_step_line = $('table.line_items.second_step').find('tr.'+line_item_num)
	first_step_estimate_total = line_item.parents('table').find('tr.total_line td.total_price strong')

	if is_enabled.val() == "t"
		is_enabled.val("f")
		second_step_line.find('td.line_ck input[type="checkbox"]').prop("checked", false)
		line_item.removeClass "selected"
	else
		is_enabled.val("t")
		second_step_line.find('td.line_ck input[type="checkbox"]').prop("checked", true)
		line_item.addClass "selected"

	updateLineTotals line_item, first_step_estimate_total

secondScreenLineItemCheckAndSelect = (line_item) ->
	is_enabled = line_item.find 'td.line_ck input[type="checkbox"]'
	line_item_num = line_item.attr("class").match(/line-id-[0-9]*/)[0]
	first_step_line = $('.select table.line_items').find('tr.'+line_item_num)

	if is_enabled.is ':checked'
		first_step_line.find('input.is_enabled').val("t")
		first_step_line.addClass 'selected'
	else
		first_step_line.find('input.is_enabled').val("f")
		first_step_line.removeClass 'selected'

firstScreenSecondScreenToggle = (line_item) ->
	# update both first and second screen toggle values together

	toggleVal = line_item.find("td.line_price_type select").val()
	otherLineItem(line_item).find("td.line_price_type select").val(toggleVal)

lineItemNum = (line_item) ->
	# to get the line item id
	line_item.attr("class").match(/line-id-[0-9]*/)[0]

otherTable = (line_item) ->
	# get the opposite table that this line item doesn't belong to
	if line_item.hasClass "select"
		other_table = $("table.line_items.second_step")
	else
		other_table = $(".select table.line_items")
	other_table

otherLineItem = (line_item) ->
	# to get the complementary line_item in the other table
	otherTable(line_item).find('tr.'+lineItemNum(line_item))

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

# removeFirstSection = (form) ->
# 	firstSection = form.find ".estimate-first-step"
# 	#console.log firstSection
# 	#firstSection.innerHTML = ''
# 	firstSection.html('')
# 	#console.log firstSection
# 	form[0].submit()

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
