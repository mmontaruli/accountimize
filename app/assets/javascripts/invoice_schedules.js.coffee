$ ->
	$body = $('body.invoice_schedules')
	$percentTotal = $('form table td.total_percent strong', $body)
	$percents = $('form table td.estimate_percentage input', $body)

	$percents.live "blur", ->
		updatePercentTotal $(this), $percentTotal
		addWarning $percentTotal

	$("form table td.line_links .delete_link a", $body).live "click", ->
		subtractRemovedPercentage($(this).parents("tr").find("td.estimate_percentage input"), $percentTotal)
		addWarning $percentTotal

updatePercentTotal = (percent, percentTotal) ->
	percents = percent.parents("table").find("td.estimate_percentage input:visible")
	warning = $(".schedule-table .warning")
	newPercentTotal = 0
	percents.each ->
		number = Number $(this).val()
		newPercentTotal += number
	newPercentTotal += " %"
	percentTotal.html(newPercentTotal)

subtractRemovedPercentage = (percent, percentTotal) ->
	newPercentTotal = percentTotal.html()
	newPercentTotal = newPercentTotal.slice(0,-2)
	newPercentTotal = Number newPercentTotal
	number = Number percent.val()
	newPercentTotal -= number
	newPercentTotal += " %"
	percentTotal.html(newPercentTotal)

addWarning = (percentTotal) ->
	warning = $(".schedule-table .warning")
	newPercentTotal = percentTotal.html()
	newPercentTotal = newPercentTotal.slice(0,-2)
	newPercentTotal = Number newPercentTotal
	if newPercentTotal != 100
		percentTotal.parent().addClass("alert")
		warning.show()
	else
		percentTotal.parent().removeClass("alert")
		warning.hide()

