# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ -> 
	lineItemInput = $('table.line_items tr.edit td.editable input')

	lineItemInput.hover ->
		$(this).parent().addClass('hover')
	, ->
		$(this).parent().removeClass('hover')
	
	lineItemInput.focus ->
		$(this).parent().addClass('focus')
	lineItemInput.blur ->
		$(this).parent().removeClass('focus')