$ ->
	$scheduleBody = $('body.invoice_schedules')
	$percentTotal = $('form table td.total_percent strong', $scheduleBody)
	$percents = $('form table td.estimate_percentage input', $scheduleBody)

	$percents.live "blur", ->
		addWarning $percentTotal

	$("form table td.line_links .delete_link a", $scheduleBody).live "click", ->
		addWarning $percentTotal

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

