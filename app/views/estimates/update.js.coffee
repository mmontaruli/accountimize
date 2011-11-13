flashNotice = $('p#notice')

flashNotice.hide()

flashNotice.html "<span><%= escape_javascript('Estimate updated successfully!') %></span>"

$('#content>form').replaceWith "<%= escape_javascript(render('form')) %>"

flashNotice.slideDown(200).delay(1500).slideUp(400)