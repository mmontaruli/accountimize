$ ->
	$scheduleBody = $('body.invoice_schedules')
	$percentTotal = $('form table td.total_percent strong', $scheduleBody)
	$percentTable = $('form table', $scheduleBody)
	percents = 'td.estimate_percentage input'
	delete_link = 'td.line_links .delete_link a'

	$percentTable.on "blur", percents, ->
		addWarning $percentTotal

	$percentTable.on "click", delete_link, ->
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

