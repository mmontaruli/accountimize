function remove_fields(link) {
  $(link).prev("input[type=hidden]").val("1");
  $(link).closest("tr").fadeOut(400);
}

function add_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g")
  $(link).closest("tr").before(content.replace(regexp, new_id));
}

//rename this function and appropriate link_to function something like
//add_negotiate_fields, etc...
function add_negotiate_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g")
  var estimateLine = $(link).closest("tr.line_item");
  if (estimateLine.nextAll("tr").eq(0).hasClass('line_item') || estimateLine.nextAll("tr").eq(0).hasClass('add_lines') || estimateLine.nextAll("tr").eq(0).hasClass('total_line')) {
    estimateLine.after(content.replace(regexp, new_id));
  } else if (estimateLine.nextAll("tr").eq(0).hasClass('negotiate_line')) {
    estimateLine.nextAll("tr.line_item, tr.add_lines, tr.total_line").eq(0).before(content.replace(regexp, new_id));
  }
}