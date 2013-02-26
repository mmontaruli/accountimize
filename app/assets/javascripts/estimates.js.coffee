$ ->
	#----- Variable Declarations -----#

	$body = $('body.estimates')
	$tableLineItems = $('table.line_items', $body)
	$estimateTotal = $('table.line_items.second_step tr.total_line td.total_price strong', $body)
	$estimateFirstStep = $('.estimate-first-step', $body)
	$estimateSecondStep = $('.estimate-second-step', $body)
	$estimateThirdStep = $('.estimate-third-step', $body)
	selectLines = 'tr.line_item.select'
	lineCk = 'tr td.line_ck input[type="checkbox"]'
	toggle = 'tr td.line_price_type select'
	lineVal = 'tr input.line_value'
	accept = 'tr td .thumbs-up input[type=checkbox]'


	#----- Function Inits -----#

	negotiateCheckAndSelect lineCk

	$tableLineItems.on "click", lineCk, ->
		secondScreenLineItemCheckAndSelect $(this).parents("tr") unless $('.estimate-first-step').length == 0 # TODO is this function needed anymore?
		updateLineTotals $(this).parents("tr"), $estimateTotal # TODO is this function needed anymore?

	$tableLineItems.on "change", toggle, ->
		fixedHourlyToggle $(this).parents("tr.line_collection>td.collection_cell>table.collection_table tr"), $(this)
		firstScreenSecondScreenToggle $(this).parents("tr") unless $('.estimate-first-step').length == 0
		updateLineTotals $(this).parents("tr.line_collection>td.collection_cell>table.collection_table tr"), $(this).parents('table').find('tr.total_line td.total_price strong')

	$tableLineItems.on "blur", lineVal, ->
		updateFixedAndHourlyValues $(this)

	$tableLineItems.on "click", accept, ->
		acceptLine $(this)
		updateLineTotals $(this).parents("tr").prevAll("tr.line_item").eq(0), $estimateTotal

	$tableLineItems.on "click", selectLines, ->
		# TODO new select functions go here
		firstScreenLineItemClickAndSelect $(this) # TODO is this function still needed?
		enableOrDisableLineItem(otherLineItem($(this)), secondStepLineIsEnabledInputVal(firstStepLineIsEnabled($(this))))
		cutAndPasteLineItem $(this)

	$body.on "click", '.estimate-first-step a.next', ->
		$estimateFirstStep.addClass("hidden")
		$estimateSecondStep.removeClass("hidden")
		$estimateSecondStep.find("table tr").each ->
			updateLineTotals $(this), $(this).parents('table').find('tr.total_line td.total_price strong')
		false

	$body.on "click", '.estimate-second-step a.back', ->
		$estimateSecondStep.addClass("hidden")
		$estimateFirstStep.removeClass("hidden")
		$estimateFirstStep.find("table tr").each ->
			updateLineTotals $(this), $(this).parents('table').find('tr.total_line td.total_price strong')
		false

	$body.on "click", '.estimate-second-step a.next', ->
		confirmationPageSort $('.estimate-second-step table')
		$estimateSecondStep.addClass("hidden")
		$estimateThirdStep.removeClass("hidden")
		false

	$body.on "click", '.estimate-third-step a.back', ->
		$estimateThirdStep.addClass("hidden")
		$estimateSecondStep.removeClass("hidden")
		false

	$(".estimate-second-step table.line_items tbody.selected, .estimate-second-step table.line_items tbody.deselected").sortable
		# helper: fixHelperModified(), # TODO helper function not working yet...
		# items: "tr.line_collection:not(.no-sort)",
		items: "tr.line_collection, tr.sort-point",
		connectWith: ".connected",
		cancel: ".no-sort",
		stop: (e, ui)->
			allowFormSelect()
			updateIndex(e, ui)
			enableOrDisableLineItem(ui.item, secondStepLineIsEnabledInputVal(secondStepLineIsEnabled(ui.item)))
			updateLineTotals ui.item.find("tr.line_item"), $estimateTotal
			secondScreenDragToSelectInFirstScreen(ui.item, secondStepLineIsEnabledInputVal(secondStepLineIsEnabled(ui.item)))
			# secondStepLineItemStyleChangeOnSelect(ui.item) # TODO temporary function, remove once css has been optimized
	.disableSelection()

	allowFormSelect()



#----- Functions -----#

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
	first_step_estimate_total = line_item.parents('table').find('tr.total_line td.total_price strong')

	if is_enabled.val() == "t"
		is_enabled.val("f")
		otherLineItem(line_item).find('td.line_ck input[type="checkbox"]').prop("checked", false)
		otherLineItem(line_item).addClass "removed"
		line_item.removeClass "selected"
	else
		is_enabled.val("t")
		otherLineItem(line_item).find('td.line_ck input[type="checkbox"]').prop("checked", true)
		otherLineItem(line_item).removeClass "removed"
		line_item.addClass "selected"

	updateLineTotals line_item, first_step_estimate_total


secondScreenLineItemCheckAndSelect = (line_item) ->
	is_enabled = line_item.find 'td.line_ck input[type="checkbox"]'

	if is_enabled.is ':checked'
		otherLineItem(line_item).find('input.is_enabled').val("t")
		otherLineItem(line_item).addClass 'selected'
	else
		otherLineItem(line_item).find('input.is_enabled').val("f")
		otherLineItem(line_item).removeClass 'selected'


firstScreenSecondScreenToggle = (line_item) ->
	# update both first and second screen toggle values together

	toggleVal = line_item.find("td.line_price_type select").val()
	otherLineItem(line_item).find("td.line_price_type select").val(toggleVal)
	fixedHourlyToggle otherLineItem(line_item), otherLineItem(line_item).find('td.line_price_type select')


lineItemNum = (line_item) ->
	# to get the line item id
	line_item.attr("class").match(/line-id-[0-9]*/)[0]

negotiateItemNum = (negotiate_item) ->
	# to get the negotiate item id
	negotiate_item.attr("class").match(/negotiate-id-[0-9]*/)[0]


otherTable = (line_item) ->
	# get the opposite table that this line item doesn't belong to
	if line_item.hasClass "select"
		other_table = $("table.line_items.second_step")
	else if line_item.hasClass "negotiate"
		other_table = $(".select table.line_items")
	else if line_item.hasClass "confirm"
		other_table = $("table.line_items.second_step")
	other_table


otherLineItem = (line_item) ->
	# to get the complementary line_item in the other table
	# TODO this function should eventually be changed to find otherLineItem Line Collection
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
	# TODO refactor this function to make shorter
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


confirmationPageSort = (estimate) ->
	# separate line items on confirmation page by their enabled status

	selectedTable = $('.confirm table.selected')
	deselectedTable = $('.confirm table.deselected')
	selectedTable.find("tbody").html("")
	deselectedTable.find("tbody").html("")

	secondStepSelectedTable = $('.negotiate table.second_step tbody.selected')
	secondStepDeselectedTable = $('.negotiate table.second_step tbody.deselected')

	$.each [secondStepSelectedTable, secondStepDeselectedTable], (tableIndex, table)->
		confirmTable = deselectedTable
		confirmTable = selectedTable if table == secondStepSelectedTable
		table.find("tr.line_collection").each ->
			rowHTML = ""
			rowHTML = rowHTML + @outerHTML
			confirmTable.append(rowHTML)

	estimateTotal = $('.negotiate table.second_step tr.total_line')[0]
	selectedTable.append(estimateTotal.outerHTML)

	# Get rid of certain columns for confirmation page
	$.each [selectedTable, deselectedTable], (tableIndex, table)->
		$.each ['td.line_ck', 'td.lock', 'td.line_links', 'tr.negotiate_line td.blank', 'tr.total_line td:first-child', 'tr.total_line td:last-child'], (colIndex, col)->
			removeColumnsFromConfirm table, col
		table.find('tr.negotiate_line').prepend('<td class="blank"></td>')
		table.find('tr.total_line td.desc').attr('colspan', '5')
		table.find('tr.line_item').removeClass('edit_true negotiate').addClass('edit_false confirm')
		table.find('tr.line_item').each ->
			# to cascade price type in negotiate screen to confirm screen
			$(this).find(".line_price_type select").val($('.negotiate table.line_items').find("." + lineItemNum($(this)) + " .line_price_type select").val())
		table.find('tr.negotiate_line.submitted').each ->
			# to cascade price type of submitted negotiate lines from negotiate to confirm screen
			$(this).find(".line_price_type select").val($('.negotiate table.line_items').find("." + negotiateItemNum($(this)) + " .line_price_type select").val())
		table.find('tr.negotiate_line.unsubmitted').each ->
			negotiateLine = $(this)
			$.each ['td.desc textarea', 'td.line_price_type select', 'td.line_qty input.line_qty', 'td.line_u_price input.line_unit_price'], (colIndex, col)->
				cascadeNegotiationToConfirm negotiateLine, col
		table.find('td input, td select, td textarea').attr('disabled', 'disabled')
		table.find('tr.negotiate_line').addClass("submitted us")

hasNegotiateLines = (lineItem) ->
	# determine if a line item has negotiate lines

	lineItem.nextAll("tr").eq(0).hasClass('negotiate_line')


lineItemAndNegotiateLines = (lineItem) ->
	# return a jquery object of a line item and its children negotiate lines

	lineRowArray = [lineItem[0]]
	nextRow = lineItem.nextAll("tr").eq(0)
	while nextRow.hasClass("negotiate_line")
		lineRowArray.push(nextRow[0])
		nextRow = nextRow.nextAll("tr").eq(0)
	lineRowArray

removeColumnsFromConfirm = (table, elem) ->
	table.find(elem).remove()

parentLineItem = (negotiateLine) ->
	# get parent line item of a negotiate line

	$(negotiateLine.prevAll("tr.line_item")[0])

otherUnsubmittedNegotiateLine = (negotiateLine) ->
	# get the other unsubmitted negotiate line

	$(otherLineItem(parentLineItem(negotiateLine)).nextAll("tr.negotiate_line.unsubmitted")[0])

cascadeNegotiationToConfirm = (negotiateLine, elem) ->
	# cascade unsubmitted values of negotiate lines to confirm screen

	negotiateLine.find(elem).val(otherUnsubmittedNegotiateLine(negotiateLine).find(elem).val())

firstStepLineIsEnabled = (elem) ->
	# determine the enabled status of a first-step line item
	status = false
	status = true if elem.find("td.line_num input.is_enabled").val() == "t"
	status

lineDestinationTable = (elem) ->
	# determine the second-step destination table of a first-step line item

	destinationTable = $("table.second_step tbody.deselected")
	destinationTable = $("table.second_step tbody.selected") if firstStepLineIsEnabled(elem)
	destinationTable

cutAndPasteLineItem = (elem) ->
	# to move corresponding second step line item from current table to new appropriate table (selected or deselected)

	# variables to get toggle value
	toggleVal = elem.find(".line_price_type select").val()
	lineItemID = lineItemNum(elem)

	# TODO once otherLineItem function is changed to find line_collection, the below can be changed back to secondStepLineItem = otherLineItem(elem)[0]
	secondStepLineItem = otherLineItem(elem).parents("tr.line_collection")[0]
	rowHTML = secondStepLineItem.outerHTML

	lineDestinationTable(elem).find("tr.drop-point").after(rowHTML)
	secondStepLineItem.outerHTML = ""

	# to cascade toggle value from first step to second step
	$("table.second_step ." + lineItemID).find(".line_price_type select").val(toggleVal)

	# to allow toggle select in second step
	allowFormSelect()

secondStepLineIsEnabled = (elem) ->

	status = false
	status = true if elem.parents("tbody").hasClass("selected")
	status

secondStepLineIsEnabledInputVal = (statusCheck) ->
	status = "f"
	status = "t" if statusCheck
	status

# secondStepLineItemStyleChangeOnSelect = (elem) ->
# 	# TODO temporary function to add/remove "removed" class

# 	lineItem = elem.find("tr.line_item")

# 	if secondStepLineIsEnabled(elem)
# 		lineItem.removeClass("removed")
# 	else
# 		lineItem.addClass("removed")

enableOrDisableLineItem = (elem, status) ->
	# enables or disables line item depending on status

	elem.find("td.line_ck input.line_item_is_enabled").val(status)

secondScreenDragToSelectInFirstScreen = (elem, status) ->
	# This probably replaces secondScreenLineItemCheckAndSelect
	# Dragging to select/deselect line item in second screen will do the same on the first screen

	firstScreenLine = otherLineItem(elem.find(".line_item"))

	firstScreenLine.removeClass("selected")
	firstScreenLine.find('input.is_enabled').val(status)
	firstScreenLine.addClass("selected") if status == "t"
